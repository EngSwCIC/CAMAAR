class FormulariosController < ApplicationController
  protect_from_forgery with: :null_session, only: :save_formulario

  before_action :set_formulario, only: %i[ show edit update destroy ]
  before_action :set_templates, only: %i[ index new ]

  def index
    @formularios = Formulario.all
    @files = Dir.glob("#{Rails.root}/public/formularios/*.json").map { |file| File.basename(file) }
  end

  def show
  end

  def new
    @formulario = Formulario.new
  end

  def edit
  end

  def create
    @formulario = Formulario.new(formulario_params)

    respond_to do |format|
      if @formulario.save
        format.html { redirect_to @formulario, notice: "Formulario foi criado com sucesso." }
        format.json { render :show, status: :created, location: @formulario }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @formulario.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @formulario.update(formulario_params)
        format.html { redirect_to @formulario, notice: "Formulario foi atualizado com sucesso." }
        format.json { render :show, status: :ok, location: @formulario }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @formulario.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @formulario.destroy
    respond_to do |format|
      format.html { redirect_to formularios_url, notice: "Formulario foi deletado com sucesso." }
      format.json { head :no_content }
    end
  end

  def save_formulario
    form_name = params[:form_name]
    professor_name = params[:professor]
    semester = params[:semester]
    questions = params[:questions]

    safe_form_name = form_name.gsub(/[^0-9A-Za-z.\- ]/, '')
    safe_professor_name = professor_name.gsub(/[^0-9A-Za-z.\- ]/, '')
    safe_semester = semester.gsub(/[^0-9A-Za-z.\- ]/, '')

    safe_file_name = "#{safe_form_name}-#{safe_professor_name}-#{safe_semester}.json"

    formulario_data = {
      name: form_name,
      professor: professor_name,
      semester: semester,
      questions: questions
    }

    File.open(Rails.root.join('public', 'formularios', safe_file_name), 'w') do |file|
      file.write(formulario_data.to_json)
    end

    folder_name = "#{safe_form_name}-#{safe_professor_name}-#{safe_semester}"
    create_response_directory(folder_name)

    render json: { status: 'success', message: 'Formulário salvo com sucesso' }
  end

  def view_file_form
    file_path = "#{Rails.root}/public/formularios/#{params[:file_name]}"
    if File.exist?(file_path)
      file_content = File.read(file_path)
      render json: { status: 'success', content: file_content }
    else
      render json: { status: 'error', message: 'File not found' }
    end
  end

  def delete_file_form
    file_name = params[:file_name]
    file_path = Rails.root.join('public', 'formularios', file_name)

    if File.exist?(file_path)
      File.delete(file_path)

      form_details = file_name.split('.json').first.split('-')
      form_name = form_details[0]
      professor_name = form_details[1]
      semester = form_details[2]

      folder_name = "#{form_name}-#{professor_name}-#{semester}"
      delete_response_directory(folder_name)

      render json: { status: 'success', message: 'Arquivo deletado com sucesso' }
    else
      render json: { status: 'error', message: 'Arquivo não encontrado' }
    end
  end




  def get_response_files
  form_name = params[:form_name]
  question_key = params[:question_key]
  base_path = Rails.root.join('public', 'respostas', form_name)
  search_pattern = "#{base_path}/*.json"
  files = Dir.glob(search_pattern)

  responses = []

  Rails.logger.debug "Procurando arquivos em: #{search_pattern}"
  Rails.logger.debug "Arquivos encontrados: #{files.inspect}"

  files.each do |file|
    if File.exist?(file)
      file_content = File.read(file)
      response_data = JSON.parse(file_content)
      if response_data[question_key]
        responses << { file: File.basename(file), response: response_data[question_key] }
      end
    end
  end

  render json: { responses: responses }
end



  def count_responses
  form_name = params[:form_name]
  professor = params[:professor]
  semester = params[:semester]
  response_path = Rails.root.join('public', 'respostas', "#{form_name}-#{professor}-#{semester}")

  puts "Counting responses in: #{response_path}" # Log do caminho
  total_responses = Dir.glob("#{response_path}/*.json").count
  puts "Total responses: #{total_responses}" # Log da contagem

  render json: { totalResponses: total_responses }
end







  private

    def list_templates
      Dir.glob("#{Rails.root}/public/templates/*.json").map { |file| File.basename(file, ".json") }
    end

    def set_templates
      @templates = list_templates
    end

    def set_formulario
      @formulario = Formulario.find(params[:id])
    end

    def formulario_params
      params.require(:formulario).permit(:template_usado, :perguntas)
    end

    def create_response_directory(folder_name)
      dir_path = Rails.root.join('public', 'respostas', folder_name)
      Dir.mkdir(dir_path) unless Dir.exist?(dir_path)
    end

    def delete_response_directory(folder_name)
      dir_path = Rails.root.join('public', 'respostas', folder_name)
      if Dir.exist?(dir_path)
        FileUtils.rm_rf(dir_path)
      end
    end
end
