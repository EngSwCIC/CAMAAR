class PasswordSetsController < ApplicationController
  skip_before_action :require_login 

  def new
    @user = User.find_by(invitation_token: params[:token])  
    if @user.nil?
      redirect_to login_path, alert: "Link inválido."
    elsif @user.invitation_token_expired?
      redirect_to login_path, alert: "Este link expirou. Solicite um novo cadastro."
    end
  end 

  def update
    @user = User.find_by(invitation_token: params[:token])  
    if @user.nil? || @user.invitation_token_expired?
      redirect_to login_path, alert: "Este link expirou. Solicite um novo cadastro." and return
    end 

    nova_senha    = params[:password]
    confirmacao   = params[:password_confirmation]  
    if nova_senha.blank? || confirmacao.blank?
      flash.now[:alert] = "Preencha todos os campos obrigatórios"
      render :new, status: :unprocessable_entity and return
    end 
    if nova_senha != confirmacao
      flash.now[:alert] = "As senhas não coincidem"
      render :new, status: :unprocessable_entity and return
    end 
    if nova_senha.length < 8
      flash.now[:alert] = "A senha deve ter no mínimo 8 caracteres"
      render :new, status: :unprocessable_entity and return
    end 
    if @user.update(password: nova_senha, password_confirmation: confirmacao)
      @user.consume_invitation_token!
      session[:user_id] = @user.id
      redirect_to home_path, notice: "Cadastro efetivado com sucesso!"
    else
      flash.now[:alert] = @user.errors.full_messages.first
      render :new, status: :unprocessable_entity
    end
  end
end