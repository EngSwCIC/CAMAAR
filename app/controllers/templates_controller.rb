class TemplatesController < ApplicationController
  layout "gerenciamento"

  before_action :set_admin
  before_action :set_template, only: %i[ show edit update destroy ]

  # GET /templates or /templates.json
  def index
    @templates = @admin.templates.includes(elementos: :campos)
  end

  # GET /templates/1 or /templates/1.json
  def show
    redirect_to admin_templates_path(@admin)
  end

  # GET /templates/new
  def new
    @templates = @admin.templates
    @template = @admin.templates.build
    elemento = @template.elementos.build
    elemento.campos.build
  end

  # GET /templates/1/edit
  def edit
    @templates = @admin.templates
    if @template.elementos.empty?
      elemento = @template.elementos.build
      elemento.campos.build
    end
  end

  # POST /templates or /templates.json
  def create
    @template = @admin.templates.build(template_params)

    respond_to do |format|
      if @template.save
        format.html { redirect_to admin_templates_path(@admin), notice: "Template criado com sucesso!" }
        format.json { render :show, status: :created, location: @template }
      else
        @templates = @admin.templates
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @template.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /templates/1 or /templates/1.json
  def update
    respond_to do |format|
      if @template.update(template_params)
        format.html { redirect_to admin_templates_path(@admin), notice: "Template atualizado com sucesso!" }
        format.json { render :show, status: :ok, location: @template }
      else
        @templates = @admin.templates
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @template.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /templates/1 or /templates/1.json
  def destroy
    @template.destroy!
    respond_to do |format|
      format.html { redirect_to admin_templates_path(@admin), notice: "Template deletado com sucesso!", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_admin
      @admin = Administrador.find(params[:admin_id])
      if @admin.id != session[:usuario_id]
        redirect_to inicio_path, alert: "Acesso negado! Você só pode acessar as suas próprias páginas."
      end
    end

    def set_template
      @template = @admin.templates.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def template_params
      params.require(:template).permit(
        :nome,
        elementos_attributes: [
          :id, :enunciado, :ordem, :_destroy,
          campos_attributes: [ :id, :tipo_elemento, :enunciado, :ordem, :_destroy ]
        ]
      )
    end
end
