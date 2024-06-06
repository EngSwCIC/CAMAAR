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

  # GET /formulario_templates/1/edit
  def edit
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
    @formulario_template.destroy!

    respond_to do |format|
      format.html { redirect_to formulario_templates_url, notice: "Formulario template was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_formulario_template
      @formulario_template = FormularioTemplate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def formulario_template_params
      params.require(:formulario_template).permit(:forms_id)
    end
end
