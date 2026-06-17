class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user, :user_signed_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id].present?
  end

  def user_signed_in?
    current_user.present?
  end

  def require_login
    redirect_to login_path, alert: "Faca login para continuar" unless user_signed_in?
  end

  def require_admin
    return if user_signed_in? && current_user.admin?

    redirect_to root_path, alert: "Acesso restrito a administradores"
  end
end
