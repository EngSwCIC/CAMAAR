# Controller base da aplicação. Define helpers de sessão e autenticação
# compartilhados por todos os outros controllers.
class ApplicationController < ActionController::Base
  helper_method :current_pessoa, :logged_in?, :is_admin?

  # Retorna a pessoa autenticada na sessão atual.
  #
  # Retorno: instância de +Pessoa+ ou +nil+ se não houver sessão ativa.
  # Efeito colateral: memoriza o resultado em @current_pessoa para evitar
  # consultas repetidas ao banco na mesma requisição.
  def current_pessoa
    @current_pessoa ||= Pessoa.find_by(usuario: session[:pessoa_id]) if session[:pessoa_id]
  end

  # Verifica se há um usuário autenticado na sessão.
  #
  # Retorno: +true+ se há sessão ativa, +false+ caso contrário.
  def logged_in?
    !!current_pessoa
  end

  # Verifica se o usuário autenticado tem privilégios de administrador.
  #
  # Retorno: +true+ se estiver logado e for admin, +false+ caso contrário.
  def is_admin?
    logged_in? && current_pessoa.admin?
  end

  # Before action que bloqueia o acesso a rotas protegidas para usuários
  # não autenticados.
  #
  # Efeito colateral: redireciona para +login_path+ com alerta se não logado.
  def require_login
    redirect_to login_path, alert: "Você precisa fazer login para acessar." unless logged_in?
  end
end
