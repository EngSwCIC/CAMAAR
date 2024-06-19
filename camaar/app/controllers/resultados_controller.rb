class ResultadosController < ApplicationController
  before_action :set_resultado, only: [:show, :edit, :update, :destroy]

  def index
    @resultados = Resultado.all
  end

  def show
  end

  def new
    @resultado = Resultado.new
  end

  def edit
  end

  def create
    @resultado = Resultado.new(resultado_params)
    if @resultado.save
      redirect_to @resultado, notice: 'Resultado foi criado com sucesso.'
    else
      render :new
    end
  end

  def update
    if @resultado.update(resultado_params)
      redirect_to @resultado, notice: 'Resultado foi atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @resultado.destroy
    redirect_to resultados_url, notice: 'Resultado foi removido com sucesso.'
  end

  private

  def set_resultado
    @resultado = Resultado.find(params[:id])
  end

  def resultado_params
    params.require(:resultado).permit(:nota, :dicente_id, :formulario_id)
  end
end
