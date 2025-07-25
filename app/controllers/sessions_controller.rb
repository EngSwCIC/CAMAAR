# frozen_string_literal: true

# Controller para gerenciar sessões de usuário (login/logout).
class SessionsController < ApplicationController
  # Desativa o layout padrão para esta página específica
  layout false, only: [:new]

  # GET /login
  #
  # Exibe o formulário de login.
  #
  def new
    # Renderiza o formulário de login
  end

  # POST /login
  #
  # Autentica o usuário e cria uma nova sessão.
  #
  # ==== Attributes
  #
  # * +email+ - O email do usuário.
  # * +password+ - A senha do usuário.
  #
  # ==== Side Effects
  #
  # * Cria uma nova sessão para o usuário se as credenciais forem válidas.
  # * Redireciona para a página de avaliações em caso de sucesso.
  # * Renderiza o formulário de login novamente em caso de falha.
  #
  def create
    user = User.find_by(email: params[:email].downcase)
    authenticate_user(user)
  end

  # DELETE /logout
  #
  # Encerra a sessão do usuário.
  #
  # ==== Side Effects
  #
  # * Destrói a sessão do usuário.
  # * Redireciona para a página de login.
  #
  def destroy
    super
  end

  protected

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[email password])
  end
end
