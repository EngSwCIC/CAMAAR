class ApplicationController < ActionController::Base
  helper_method :current_pessoa, :logged_in?, :is_admin?

  def current_pessoa
    @current_pessoa ||= Pessoa.find_by(usuario: session[:pessoa_id]) if session[:pessoa_id]
  end

  def logged_in?
    !!current_pessoa
  end

  def is_admin?
    logged_in? && current_pessoa.admin?
  end

  def require_login
    redirect_to login_path, alert: "Você precisa fazer login para acessar." unless logged_in?
  end
end