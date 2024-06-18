class DicientesController < ApplicationController
  before_action :authenticate_user!

  # GET /dicentes
  def index
    @dicientes = Dicente.all
  end

  # GET /dicentes/:id
  def show
    @dicente = Dicente.find(params[:id])
  end

  # GET /dicentes/new
  def new
    @dicente = Dicente.new
  end

  # POST /dicentes
  def create
    @dicente = Dicente.new(dicente_params)
    if @dicente.save
      redirect_to @dicente, notice: 'Dicente was successfully created.'
    else
      render :new
    end
  end

  # GET /dicentes/:id/edit
  def edit
    @dicente = Dicente.find(params[:id])
  end

  # PATCH/PUT /dicentes/:id
  def update
    @dicente = Dicente.find(params[:id])
    if @dicente.update(dicente_params)
      redirect_to @dicente, notice: 'Dicente was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /dicentes/:id
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
