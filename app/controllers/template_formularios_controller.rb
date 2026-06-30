class TemplateFormulariosController < ApplicationController
  before_action :require_login
  before_action :require_admin
  before_action :set_template, only: [:show, :edit, :update, :destroy]

  def show

  end

  def new
    @template_formulario = TemplateFormulario.new
  end

  def create
    @template_formulario = TemplateFormulario.new(template_params)
    @template_formulario.criador_formulario = current_usuario.criador_formulario

    unless @template_formulario.criador_formulario
      @template_formulario.errors.add(:base, "Administrador não possui perfil de criador de formulários.")
      return render :new, status: :unprocessable_content
    end

    if @template_formulario.save
      redirect_to edit_template_formulario_path(@template_formulario), notice: "Template iniciado. Favor adicionar as perguntas."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
    # Constroi um formulario vazio de Pergunta para que o formulario nao fique vazio
    @template_formulario.perguntas.build if @template_formulario.perguntas.empty?
  end

  def update
    if @template_formulario.update(template_params)
      redirect_to editar_templates_path, notice: "Template finalizado com sucesso." 
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    if @template_formulario.destroy
      redirect_to editar_templates_path, notice: "Template excluída com sucesso."
    else
      redirect_to editar_templates_path, alert: "Não foi possível excluir: #{@template_formulario.errors.full_messages.to_sentence}"
    end
  end

  private

  def set_template
    @template_formulario = TemplateFormulario.find(params[:id])
  end

  def template_params
    params.require(:template_formulario).permit(
      :nome_template,
      perguntas_attributes: [
        :id, :tipo_pergunta, :enunciado, :numero_opcoes, 
        :gabarito_discursiva, :gabarito_radio, :_destroy,
        opcoes_radio: [] 
      ]
    )
  end
end