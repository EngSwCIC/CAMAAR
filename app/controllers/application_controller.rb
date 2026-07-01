class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  before_action :require_login

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  helper_method :current_user

  def require_login
    if current_user.nil?
      redirect_to login_path, alert: "Faça login para continuar."
    elsif current_user.password_digest.nil? && current_user.invitation_token.present?
      redirect_to password_set_path(current_user.invitation_token), notice: "Você precisa definir uma senha antes de continuar"
    end
  end

  def admin?
    current_user&.role == "admin"
  end
  helper_method :admin?

  def require_admin
    unless admin?
      redirect_to avaliacoes_path, alert: "Acesso não autorizado"
    end
  end
end
