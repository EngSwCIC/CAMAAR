class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  def new
  end

  def create
    user = User.find_by_login(params[:login])

    if user
      user.generate_reset_token!
      UserMailer.reset_password(user).deliver_later
    end

    redirect_to login_path,
      flash: { success: "Se esse cadastro existir, você receberá um e-mail com o link para redefinir sua senha." }
  end

  def edit
    @user = User.find_by(reset_token: params[:token])

    if @user.nil?
      redirect_to login_path, alert: "Link inválido." and return
    elsif @user.reset_token_expired?
      redirect_to login_path, alert: "Este link expirou. Solicite um novo link." and return
    end
  end

  def update
    @user = User.find_by(reset_token: params[:token])

    if @user.nil? || @user.reset_token_expired?
      redirect_to login_path, alert: "Este link expirou. Solicite um novo link." and return
    end

    nova_senha  = params[:password]
    confirmacao = params[:password_confirmation]

    if nova_senha.blank? || confirmacao.blank?
      flash.now[:alert] = "Preencha todos os campos obrigatórios"
      render :edit, status: :unprocessable_entity and return
    end

    if nova_senha != confirmacao
      flash.now[:alert] = "As senhas não coincidem"
      render :edit, status: :unprocessable_entity and return
    end

    if nova_senha.length < 8
      flash.now[:alert] = "A senha deve ter no mínimo 8 caracteres"
      render :edit, status: :unprocessable_entity and return
    end

    if @user.update(password: nova_senha, password_confirmation: confirmacao)
      @user.consume_reset_token!
      redirect_to login_path, flash: { success: "Senha redefinida com sucesso. Faça seu login." }
    else
      flash.now[:alert] = @user.errors.full_messages.first
      render :edit, status: :unprocessable_entity
    end
  end
end