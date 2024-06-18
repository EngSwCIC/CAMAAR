class DocentesController < ApplicationController
  before_action :authenticate_user!

  # GET /docentes
  def index
    @docentes = Docente.all
  end

  # GET /docentes/:id
  def show
    @docente = Docente.find(params[:id])
  end

  # GET /docentes/new
  def new
    @docente = Docente.new
  end

  # POST /docentes
  def create
    @docente = Docente.new(docente_params)
    if @docente.save
      redirect_to @docente, notice: 'Docente was successfully created.'
    else
      render :new
    end
  end

  # GET /docentes/:id/edit
  def edit
    @docente = Docente.find(params[:id])
  end

  # PATCH/PUT /docentes/:id
  def update
    @docente = Docente.find(params[:id])
    if @docente.update(docente_params)
      redirect_to @docente, notice: 'Docente was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /docentes/:id
  def destroy
    @docente = Docente.find(params[:id])
    @docente.destroy
    redirect_to docentes_url, notice: 'Docente was successfully destroyed.'
  end

  private

  def docente_params
    params.require(:docente).permit(:nome, :email, :password, :type, :usuario, :formacao, :departamento)
  end
end
