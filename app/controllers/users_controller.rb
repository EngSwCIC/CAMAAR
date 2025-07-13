class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]

  # Exibe formulário de cadastro
  def new
    @user = User.new
  end

  # Processa o cadastro
  def create
    @user = User.new(user_params)
    
    if @user.save
      login(@user)
      redirect_to root_path, notice: 'Cadastro realizado com sucesso!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end