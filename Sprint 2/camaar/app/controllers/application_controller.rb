class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def require_admin!
    unless current_user&.admin?
      redirect_to dashboard_path, alert: 'Acesso restrito.'
    end
  end
end
