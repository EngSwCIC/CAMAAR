class AdministradoresController < ApplicationController
  before_action :set_administrador, only: [:show, :edit, :update, :destroy]

  def index
    @administradores = Administrador.all
  end

  def show
  end

  def new
    @administrador = Administrador.new
  end

  def edit
  end

  def create
    @administrador = Administrador.new(administrador_params)

    if @administrador.save
      redirect_to @administrador, notice: 'Administrador criado com sucesso.'
    else
      render :new
    end
  end

  def update
    if @administrador.update(administrador_params)
      redirect_to @administrador, notice: 'Administrador atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @administrador.destroy
    redirect_to administradores_url, notice: 'Administrador excluído com sucesso.'
  end

  private

  def set_administrador
    @administrador = Administrador.find(params[:id])
  end

  def administrador_params
    params.require(:administrador).permit(:nome, :senha)
  end
end
