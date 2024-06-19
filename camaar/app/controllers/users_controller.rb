class UsersController < ApplicationController
  before_action :authenticate_user!

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/:id
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  def create
    # Determine qual tipo de usuário está sendo criado com base nos parâmetros
    if user_params[:type] == 'Docente'
      @user = Docente.new(user_params.except(:type, :matricula, :curso))
    elsif user_params[:type] == 'Dicente'
      @user = Dicente.new(user_params.except(:type, :departamento))
    else
      @user = User.new(user_params)
    end

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  # GET /users/:id/edit
  def edit
    @user = User.find(params[:id])
  end

  # PATCH/PUT /users/:id
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/:id
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

  def user_params
    params.require(:user).permit(:nome, :email, :password, :type, :usuario, :formacao, :matricula, :curso, :departamento)
  end
end
