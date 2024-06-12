class DicentesController < ApplicationController
  before_action :set_dicente, only: [:show, :edit, :update, :destroy]

  def index
    @dicentes = Dicente.all
  end

  def show
  end

  def new
    @dicente = Dicente.new
  end

  def edit
  end

  def create
    @dicente = Dicente.new(dicente_params)

    if @dicente.save
      redirect_to @dicente, notice: 'Dicente criado com sucesso.'
    else
      render :new
    end
  end

  def update
    if @dicente.update(dicente_params)
      redirect_to @dicente, notice: 'Dicente atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @dicente.destroy
    redirect_to dicentes_url, notice: 'Dicente excluído com sucesso.'
  end

  private

  def set_dicente
    @dicente = Dicente.find(params[:id])
  end

  def dicente_params
    params.require(:dicente).permit(:nome, :senha, :matricula, :turma_id)
  end
end
