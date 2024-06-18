class DicentesController < ApplicationController
  before_action :set_dicente, only: [:show, :edit, :update, :destroy]

  # GET /dicentes
  def index
    @dicentes = Dicente.all
  end

  # GET /dicentes/:id
  def show
  end

  # GET /dicentes/new
  def new
    @dicente = Dicente.new
    @user = User.new
  end

  # POST /dicentes
  def create
    @user = User.new(user_params)
    @dicente = Dicente.new(dicente_params)
    if @dicente.save
      redirect_to @dicente, notice: 'Dicente was successfully created.'
    else
      render :new
    end
  end

  # GET /dicentes/:id/edit
  def edit
  end

  # PATCH/PUT /dicentes/:id
  def update
    if @dicente.update(dicente_params)
      redirect_to @dicente, notice: 'Dicente was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /dicentes/:id
  def destroy
    @dicente.destroy
    redirect_to dicientes_url, notice: 'Dicente was successfully destroyed.'
  end

  private
  def set_dicente
    @dicente = Dicente.find(params[:id])
  end

  def dicente_params
    params.require(:dicente).permit(:user_id, :matricula, :curso)
  end

  def user_params
    params.require(:user).permit(:nome, :email, :password, :usuario, :formacao)
  end
end
