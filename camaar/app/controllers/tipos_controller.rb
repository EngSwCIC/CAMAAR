class TiposController < ApplicationController
  def index
    @tipos = Tipo.all
  end

  def show
    @tipo = Tipo.find(params[:id])
  end

  def new
    @tipo = Tipo.new
  end

  def create
    @tipo = Tipo.new(tipo_params)
    if @tipo.save
      redirect_to @tipo
    else
      flash[:alert] = "Infelizmente houve um erro na criação de seu tipo"
      render 'new'
    end
  end

  def edit
    @tipo = Tipo.find(params[:id])
  end

  def update
    @tipo = Tipo.find(params[:id])
    if @tipo.update(tipo_params)
      redirect_to @tipo
    else
      render 'edit'
    end
  end

  def destroy
    @tipo = Tipo.find(params[:id])
    @tipo.destroy
    redirect_to tipos_path
  end

  private

  def tipo_params
    params.require(:tipo).permit(:numeroDeAlternativas, :discursiva?, :nome, :fatorDeCorreção?)
  end
end
