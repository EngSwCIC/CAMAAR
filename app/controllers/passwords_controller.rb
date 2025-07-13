class PasswordsController < ApplicationController
  before_action :load_user, only: [:edit, :update]

  # Exibe o formulário para solicitar reset de senha
  def new
  end

  # Processa a solicitação de reset
  def create
    @user = User.find_by(email: params[:email])
    
    if @user
      @user.generate_password_reset_token!
      UserMailer.password_reset(@user).deliver_now
      redirect_to login_path, notice: 'Instruções para resetar sua senha foram enviadas para seu email.'
    else
      flash.now[:alert] = 'Email não encontrado'
      render :new, status: :unprocessable_entity
    end
  end

  # Exibe o formulário para criar nova senha
  def edit
    unless @user&.password_reset_token_valid?
      redirect_to new_password_path, alert: 'Link de reset de senha expirado ou inválido.'
    end
  end

  # Processa a atualização da senha
  def update
    if @user.password_reset_token_valid? && @user.update(password_params)
      @user.clear_password_reset_token!
      redirect_to login_path, notice: 'Senha atualizada com sucesso!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def load_user
    @user = User.find_by(password_reset_token: params[:id])
    redirect_to new_password_path, alert: 'Link inválido' unless @user
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end