class FormulariosController < ApplicationController
  def index
    @formularios = Formulario.all
  end

  def show
    @formulario = Formulario.find(params[:id])
  end

  def new
    @formulario = Formulario.new
    @templates = Template.all
  end

  def create
    @formulario = Formulario.new(formulario_params)
    @formulario.administrador = current_administrador
    if @formulario.save
      redirect_to @formulario
    else
      @templates = Template.all
      render 'new'
    end
  end

  def edit
    @formulario = Formulario.find(params[:id])
  end

  def update
    @formulario = Formulario.find(params[:id])
    if @formulario.update(formulario_params)
      redirect_to @formulario
    else
      render 'edit'
    end
  end

  def destroy
    @formulario = Formulario.find(params[:id])
    @formulario.destroy
    redirect_to formularios_path
  end

  private

  def formulario_params
    params.require(:formulario).permit(
      :turmas, :dataDeTermino,{ Resultados: {} },
      questaos_attributes: [:template_id, :pergunta, :alternativas, :pontos, :fatorDeCorrecao, :alternativaCorreta]
    )
  end
end
