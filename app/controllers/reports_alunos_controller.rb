class ReportsAlunosController < ApplicationController
  before_action :set_reports_aluno, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token, only: [:submit_form]

  # GET /reports_alunos or /reports_alunos.json
  def index
    @reports_alunos = ReportsAluno.all
    @formularios = Dir.glob(Rails.root.join('public', 'formularios', '*.json')).map do |file_path|
      File.basename(file_path)
    end
  end

  # GET /fetch_form
  def fetch_form
    file_path = Rails.root.join('public', 'formularios', params[:file_name])
    if File.exist?(file_path)
      render json: JSON.parse(File.read(file_path))
    else
      render json: { error: "File not found" }, status: 404
    end
  end

  # POST /submit_form
  def submit_form
    json_data = JSON.parse(request.body.read)
    file_name = json_data['fileName']
    data = json_data['data']
    form_name = json_data['formName']
    professor = json_data['professor']
    semester = json_data['semester']

    directory = Rails.root.join('public', 'respostas', "#{form_name}-#{professor}-#{semester}")
    Dir.mkdir(directory) unless Dir.exist?(directory)

    file_path = directory.join(file_name)
    
    Rails.logger.info "Saving file to: #{file_path}"

    begin
      File.open(file_path, 'w') do |file|
        file.write(JSON.pretty_generate(data))
      end
      render json: { success: true, file_path: file_path.to_s }
    rescue => e
      Rails.logger.error "Error: #{e.message}"    # Log para verificar erros
      render json: { success: false, error: e.message }
    end
  end

  # GET /reports_alunos/1 or /reports_alunos/1.json
  def show
  end

  # GET /reports_alunos/new
  def new
    @reports_aluno = ReportsAluno.new
  end

  # GET /reports_alunos/1/edit
  def edit
  end

  # POST /reports_alunos or /reports_alunos.json
  def create
    @reports_aluno = ReportsAluno.new(reports_aluno_params)

    respond_to do |format|
      if @reports_aluno.save
        format.html { redirect_to reports_aluno_url(@reports_aluno), notice: "Reports aluno was successfully created." }
        format.json { render :show, status: :created, location: @reports_aluno }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reports_aluno.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports_alunos/1 or /reports_alunos/1.json
  def update
    respond_to do |format|
      if @reports_aluno.update(reports_aluno_params)
        format.html { redirect_to reports_aluno_url(@reports_aluno), notice: "Reports aluno was successfully updated." }
        format.json { render :show, status: :ok, location: @reports_aluno }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reports_aluno.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports_alunos/1 or /reports_alunos/1.json
  def destroy
    @reports_aluno.destroy!

    respond_to do |format|
      format.html { redirect_to reports_alunos_url, notice: "Reports aluno was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reports_aluno
      @reports_aluno = ReportsAluno.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reports_aluno_params
      params.require(:reports_aluno).permit(:formulario_id)
    end
end
