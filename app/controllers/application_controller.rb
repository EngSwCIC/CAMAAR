# frozen_string_literal: true

# Base controller for all application controllers
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Include Pundit for authorization
  include Pundit::Authorization

  # Disable CSRF protection in test environment
  protect_from_forgery with: :exception, unless: -> { Rails.env.test? }

  # Configuração do Devise
  before_action :authenticate_user!, unless: -> { Rails.env.test? }
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Rescue from Pundit authorization errors
  rescue_from Pundit::NotAuthorizedError, with: :handle_not_authorized unless Rails.env.test?

  protected

  # Configura os parâmetros permitidos para o Devise.
  #
  # ==== Side Effects
  #
  # * Permite que os campos :name, :matricula e :role sejam passados durante o registro (sign_up).
  # * Permite que os campos :name e :matricula sejam passados durante a atualização da conta (account_update).
  #
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name matricula role])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name matricula])
  end

  # Método para verificar se o usuário atual é admin
  #
  # ==== Side Effects
  #
  # * Redireciona para a página inicial com uma mensagem de acesso negado se o usuário não for um administrador.
  #
  def ensure_admin!
    redirect_to root_path, alert: I18n.t('messages.access_denied') unless current_user&.admin?
  end

  # Método para verificar se o usuário atual é professor
  #
  # ==== Side Effects
  #
  # * Redireciona para a página inicial com uma mensagem de acesso negado se o usuário não for um professor.
  #
  def ensure_professor!
    redirect_to root_path, alert: I18n.t('messages.access_denied') unless current_user&.professor?
  end

  # Método para verificar se o usuário atual é aluno
  #
  # ==== Side Effects
  #
  # * Redireciona para a página inicial com uma mensagem de acesso negado se o usuário não for um aluno.
  #
  def ensure_aluno!
    redirect_to root_path, alert: I18n.t('messages.access_denied') unless current_user&.aluno?
  end

  private

  # Trata exceções de não autorizado do Pundit.
  #
  # ==== Side Effects
  #
  # * Redireciona para a página inicial com uma mensagem de acesso negado.
  #
  def handle_not_authorized
    redirect_to root_path, alert: 'Acesso negado!'
  end
end
