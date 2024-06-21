class TemplatesController < ApplicationController
  before_action :set_template, only: [:show, :edit, :update, :destroy]

  def index
    if params[:nome].present?
      @templates = Template.where("nome LIKE ?", "%#{params[:nome]}%")
    else
      @templates = Template.all
    end
  end

  def show
  end

  def new
    @template = Template.new
    @tipos = Tipo.all
  end

  def create
    @template = Template.new(template_params)
    @template.docente = current_user.docente
    if @template.save
      redirect_to @template, notice: 'Template was successfully created.'
    else
      @tipos = Tipo.all
      render :new
    end
  end

  def edit
    @tipos = Tipo.all
  end

  def update
    if @template.update(template_params)
      redirect_to @template, notice: 'Template was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @template.destroy
    redirect_to templates_url, notice: 'Template was successfully destroyed.'
  end

  private

  def set_template
    @template = Template.find(params[:id])
  end

  def template_params
    params.require(:template).permit(:nome, questaos_attributes: [:id, :pergunta, :pontos, :fatorDeCorrecao, :tipo_id, :_destroy, alternativas_attributes: [:id, :texto, :_destroy]])
  end
end
