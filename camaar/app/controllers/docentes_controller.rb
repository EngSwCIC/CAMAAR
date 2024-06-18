class DocentesController < ApplicationController
  before_action :set_docente, only: [:show, :edit, :update, :destroy]

  # GET /docentes
  def index
    @docentes = Docente.all
  end

  # GET /docentes/1
  def show
  end

  # GET /docentes/new
  def new
    @docente = Docente.new
    @user = User.new
  end

  # GET /docentes/1/edit
  def edit
  end

  # POST /docentes
  def create
    @user = User.new(user_params)
    @docente = Docente.new(docente_params)
    @docente.user = @user

    if @user.save && @docente.save
      redirect_to @docente, notice: 'Docente foi criado com sucesso.'
    else
      render :new
    end
  end

  # PATCH/PUT /docentes/1
  def update
    if @docente.update(docente_params)
      redirect_to @docente, notice: 'Docente foi atualizado com sucesso.'
    else
      render :edit
    end
  end

  # DELETE /docentes/1
  def destroy
    @docente.destroy
    redirect_to docentes_url, notice: 'Docente foi excluído com sucesso.'
  end

  private

  def set_docente
    @docente = Docente.find(params[:id])
  end

  def docente_params
    params.require(:docente).permit(:user_id, :departamento)
  end

  def user_params
    params.require(:user).permit(:nome, :email, :password, :usuario, :formacao)
  end
end
