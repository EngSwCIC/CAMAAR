class FormularioTemplatesController < ApplicationController
  before_action :set_formulario_template, only: %i[ show edit update destroy ]

  # GET /formulario_templates or /formulario_templates.json
  def index
    @formulario_templates = FormularioTemplate.all
  end

  # GET /formulario_templates/1 or /formulario_templates/1.json
  def show
  end

  # GET /formulario_templates/new
  def new
    @formulario_template = FormularioTemplate.new
  end

  def set_no_cache
    response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, max-age=0"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  # GET /formulario_templates/1/edit
  def edit
  end

  # GET /formulario_templates/edit_no_params
  def edit_template
    templates_dir = Rails.root.join('public', 'templates')
    @files = Dir.children(templates_dir).select { |file| file.end_with?('.json') }

    @formulario_template = FormularioTemplate.first # ou outro critério
    render :edit
  end

  # POST /formulario_templates or /formulario_templates.json
  def create
    @formulario_template = FormularioTemplate.new(formulario_template_params)

    respond_to do |format|
      if @formulario_template.save
        format.html { redirect_to formulario_template_url(@formulario_template), notice: "Formulario template was successfully created." }
        format.json { render :show, status: :created, location: @formulario_template }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @formulario_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /formulario_templates/1 or /formulario_templates/1.json
  def update
    respond_to do |format|
      if @formulario_template.update(formulario_template_params)
        format.html { redirect_to formulario_template_url(@formulario_template), notice: "Formulario template was successfully updated." }
        format.json { render :show, status: :ok, location: @formulario_template }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @formulario_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /formulario_templates/1 or /formulario_templates/1.json
  def destroy
    @formulario_template.destroy

    respond_to do |format|
      format.html { redirect_to formulario_templates_url, notice: "Formulario template was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def delete_file
    file_name = params[:file_name]
    file_path = Rails.root.join('public', 'templates', file_name)
    
    if File.exist?(file_path)
      File.delete(file_path)
      render json: { status: 'success', message: 'File deleted successfully' }
    else
      render json: { status: 'error', message: 'File not found' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_formulario_template
      @formulario_template = FormularioTemplate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def formulario_template_params
      params.require(:formulario_template).permit(:name, :content)
    end
end
