class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  helper_method :workspace, :current_user, :admin_signed_in?

  private

  def workspace
    @workspace ||= Camaar::Workspace.new(session)
  end

  def current_user
    @current_user ||= Usuario.find_by(id: session[:usuario_id]) if session[:usuario_id]
  end

  def admin_signed_in?
    current_user&.is_a?(Administrador)
  end

  def require_login
    unless current_user
      redirect_to root_path, alert: "Por favor, faça login primeiro"
    end
  end

  def require_admin
    unless admin_signed_in?
      redirect_to inicio_path, alert: "Acesso restrito a administradores"
    end
  end
end
