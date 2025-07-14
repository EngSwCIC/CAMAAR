# frozen_string_literal: true

# Adicione um comentário de documentação para a classe SessionsController.
class SessionsController < ApplicationController
  # Desativa o layout padrão para esta página específica
  # Ignora a verificação de login para as páginas de 'new' (formulário) e 'create' (processamento)
  skip_before_action :authenticate_user!, only: %i[new create]
  layout false, only: [:new] # Continua sem layout na página de login

  def new
    # Renderiza o formulário de login
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    authenticate_user(user)
  end

  def destroy
    # Apaga a sessão do usuário
    session[:user_id] = nil
    redirect_to login_path, notice: I18n.t('messages.logout_success')
  end

  private

  def authenticate_user(user)
    if valid_user_credentials?(user)
      login_user(user)
    else
      handle_invalid_credentials
    end
  rescue BCrypt::Errors::InvalidHash
    handle_authentication_error
  end

  def valid_user_credentials?(user)
    user && user.password_digest.present? && user.authenticate(params[:password])
  end

  def login_user(user)
    session[:user_id] = user.id
    redirect_to evaluations_path, notice: I18n.t('messages.login_success')
  end

  def handle_invalid_credentials
    flash.now[:alert] = I18n.t('messages.login_failed')
    render :new, status: :unprocessable_entity
  end

  def handle_authentication_error
    flash.now[:alert] = I18n.t('messages.auth_error')
    render :new, status: :unprocessable_entity
  end
end
