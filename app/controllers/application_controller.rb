class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  stale_when_importmap_changes

  helper_method :current_user, :admin?, :current_admin_departamentos,
                :usuario_logado, :discente_logado?, :docente_logado?, :admin_logado?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def admin?
    current_user&.perfil == "Administrador"
  end

  def current_admin_departamentos
    @current_admin_departamentos ||= current_user&.departamentos || Departamento.none
  end

  def discente_atual
    current_user
  end

  def usuario_logado
    current_user
  end

  def discente_logado?
    current_user&.perfil == "Discente"
  end

  def docente_logado?
    current_user&.perfil == "Docente"
  end

  def admin_logado?
    admin?
  end

  def require_login
    redirect_to login_path, alert: "Você precisa estar logado." unless current_user
  end

  def require_admin
    redirect_to root_path, alert: "Acesso restrito a administradores" unless admin? && current_admin_departamentos.exists?
  end

  def exigir_discente!
    redirect_to root_path, alert: "Acesso restrito a discentes." unless current_user&.perfil == "Discente"
  end
end
