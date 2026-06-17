class PasswordsController < ApplicationController
  # No authentication required for these actions
  skip_before_action :require_user, raise: false

  def setup
    @token = params[:token]
    @user = Usuario.find_by(setup_token: @token)

    if @user.nil?
      flash.now[:alert] = "Link inválido"
      render :setup_error and return
    end

    if @user.setup_token_used?
      flash.now[:alert] = "Este link já foi utilizado. Faça login normalmente"
      render :setup_error and return
    end

    if @user.setup_token_sent_at.nil? || @user.setup_token_sent_at < 24.hours.ago
      flash.now[:alert] = "Link expirado. Solicite um novo e-mail de cadastro ao administrador"
      render :setup_error and return
    end
  end

  def setup_update
    @token = params[:token]
    @user = Usuario.find_by(setup_token: @token)

    if @user.nil?
      flash.now[:alert] = "Link inválido"
      redirect_to login_path and return
    end

    # Check for empty inputs explicitly before updating attributes to get "Preencha todos os campos obrigatórios"
    if params[:password].blank? || params[:password_confirmation].blank?
      flash.now[:alert] = "Preencha todos os campos obrigatórios"
      render :setup and return
    end

    @user.validating_password_rules = true
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]

    if @user.valid?
      @user.setup_token_used = true
      @user.ativo = true
      @user.save!
      session[:usuario_id] = @user.id
      flash[:notice] = "Senha definida com sucesso. Bem-vindo!"
      redirect_to avaliacoes_path
    else
      flash.now[:alert] = @user.errors[:password].first
      render :setup, status: :unprocessable_entity
    end
  end

  def forgot
    # Render forgot page
  end

  def forgot_send
    email = params[:email]&.strip

    if email.blank?
      flash.now[:alert] = "Preencha o campo de e-mail"
      render :forgot, status: :unprocessable_entity and return
    end

    unless email.include?("@")
      flash.now[:alert] = "E-mail inválido"
      render :forgot, status: :unprocessable_entity and return
    end

    user = Usuario.find_by(email: email)
    if user
      user.generate_reset_token!
      # Simulating email dispatch
    end

    flash[:notice] = "Se este e-mail estiver cadastrado, você receberá as instruções em breve"
    redirect_to login_path
  end

  def reset
    @token = params[:token]
    @user = Usuario.find_by(reset_token: @token)

    if @user.nil?
      flash.now[:alert] = "Link inválido"
      render :setup_error and return
    end

    if @user.reset_token_used?
      flash.now[:alert] = "Este link já foi utilizado. Solicite uma nova redefinição de senha"
      render :setup_error and return
    end

    if @user.reset_token_sent_at.nil? || @user.reset_token_sent_at < 24.hours.ago
      flash.now[:alert] = "Link expirado. Solicite uma nova redefinição de senha"
      render :setup_error and return
    end
  end

  def reset_update
    @token = params[:token]
    @user = Usuario.find_by(reset_token: @token)

    if @user.nil?
      flash.now[:alert] = "Link inválido"
      redirect_to login_path and return
    end

    if @user.reset_token_sent_at.nil? || @user.reset_token_sent_at < 24.hours.ago
      flash.now[:alert] = "Link expirado. Solicite uma nova redefinição de senha"
      render :reset, status: :unprocessable_entity and return
    end

    if params[:password].blank? || params[:password_confirmation].blank?
      flash.now[:alert] = "Preencha todos os campos obrigatórios"
      render :reset and return
    end

    # Check if new password is equal to old password
    if @user.authenticate(params[:password])
      flash.now[:alert] = "A nova senha não pode ser igual à senha anterior"
      render :reset, status: :unprocessable_entity and return
    end

    @user.validating_password_rules = true
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]

    if @user.valid?
      @user.reset_token_used = true
      @user.save!
      flash[:notice] = "Senha redefinida com sucesso. Faça login com sua nova senha"
      redirect_to login_path
    else
      flash.now[:alert] = @user.errors[:password].first
      render :reset, status: :unprocessable_entity
    end
  end
end
