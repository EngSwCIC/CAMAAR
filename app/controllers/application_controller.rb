# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Configuração do Devise
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name matricula role])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name matricula])
  end

  # Método para verificar se o usuário atual é admin
  def ensure_admin!
    redirect_to root_path, alert: 'Acesso negado!' unless current_user&.admin?
  end

  # Método para verificar se o usuário atual é professor
  def ensure_professor!
    redirect_to root_path, alert: 'Acesso negado!' unless current_user&.professor?
  end

  # Método para verificar se o usuário atual é aluno
  def ensure_aluno!
    redirect_to root_path, alert: 'Acesso negado!' unless current_user&.aluno?
  end
end
