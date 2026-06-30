class ApplicationController < ActionController::Base
  helper_method :current_usuario, :logged_in?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  stale_when_importmap_changes
  private

  def current_usuario
    @current_usuario ||= Usuario.find_by(id: session[:usuario_id]) if session[:usuario_id]
  end

  alias_method :current_user, :current_usuario

  def logged_in?
    current_usuario.present?
  end

  def require_login
    redirect_to login_path, alert: "É necessário estar logado para acessar esta página." unless logged_in?
  end

  def require_admin
    unless current_usuario&.admin?
      redirect_to root_path, alert: "Você não tem permissão para acessar esta página."
    end
  end

  def require_coordinator
    unless current_usuario&.admin?
      redirect_to root_path, alert: "A turma não pertence ao seu departamento."
    end
  end
end
