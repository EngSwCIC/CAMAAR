class TurmasController < ApplicationController
  before_action :set_turma, only: [:show, :edit, :update, :destroy]

  def index
    @turmas = Turma.all
  end

  def show
  end

  def new
    @turma = Turma.new
  end

  def edit
  end

  def create
    @turma = Turma.new(turma_params)

    if @turma.save
      redirect_to @turma, notice: 'Turma criada com sucesso.'
    else
      render :new
    end
  end

  def update
    if @turma.update(turma_params)
      redirect_to @turma, notice: 'Turma atualizada com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @turma.destroy
    redirect_to turmas_url, notice: 'Turma excluída com sucesso.'
  end

  private

  def set_turma
    @turma = Turma.find(params[:id])
  end

  def turma_params
    params.require(:turma).permit(:nome)
  end
end
