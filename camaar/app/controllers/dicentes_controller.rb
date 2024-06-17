# app/controllers/dicientes_controller.rb
class DicientesController < ApplicationController
  before_action :authenticate_user!

  # GET /dicientes
  def index
    @dicientes = Dicente.all
  end

  # GET /dicientes/:id
  def show
    @dicente = Dicente.find(params[:id])
  end

  # GET /dicientes/new
  def new
    @dicente = Dicente.new
  end

  # POST /dicientes
  def create
    @dicente = Dicente.new(dicente_params)
    if @dicente.save
      redirect_to @dicente, notice: 'Dicente was successfully created.'
    else
      render :new
    end
  end

  # GET /dicientes/:id/edit
  def edit
    @dicente = Dicente.find(params[:id])
  end

  # PATCH/PUT /dicientes/:id
  def update
    @dicente = Dicente.find(params[:id])
    if @dicente.update(dicente_params)
      redirect_to @dicente, notice: 'Dicente was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /dicientes/:id
  def destroy
    @dicente = Dicente.find(params[:id])
    @dicente.destroy
    redirect_to dicientes_url, notice: 'Dicente was successfully destroyed.'
  end

  private

  def dicente_params
    params.require(:dicente).permit(:nome, :email, :password, :type, :usuario, :formacao, :matricula, :curso)
  end
end
