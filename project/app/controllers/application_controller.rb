##
# Controller base da aplicação. Centraliza a identificação do usuário da sessão
# e as verificações de autenticação e autorização usadas pelos demais controllers.
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_admin, :current_user, :user_signed_in?

  private

  ##
  # Recupera o usuário autenticado na sessão atual.
  #
  # Não recebe argumentos.
  #
  # Retorna o User autenticado ou +nil+ quando a sessão não possui um usuário válido.
  #
  # Efeitos colaterais: consulta o banco na primeira chamada e memoriza o resultado
  # em uma variável de instância.
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id].present?
  end

  ##
  # Identifica se o usuário autenticado possui o papel de administrador.
  #
  # Não recebe argumentos.
  #
  # Retorna o User administrador ou +nil+ para participantes e visitantes.
  #
  # Efeitos colaterais: pode carregar o usuário da sessão por meio de #current_user.
  def current_admin
    current_user&.admin? ? current_user : nil
  end

  ##
  # Informa se existe um usuário autenticado.
  #
  # Não recebe argumentos.
  #
  # Retorna +true+ quando há um usuário na sessão e +false+ caso contrário.
  #
  # Efeitos colaterais: pode carregar o usuário da sessão por meio de #current_user.
  def user_signed_in?
    current_user.present?
  end

  ##
  # Exige autenticação antes de continuar a requisição.
  #
  # Não recebe argumentos.
  #
  # Retorna +nil+; o resultado relevante é a continuidade ou interrupção da requisição.
  #
  # Efeitos colaterais: redireciona visitantes para o login e define uma mensagem de alerta.
  def require_login
    redirect_to login_path, alert: "Faça login para continuar" unless user_signed_in?
  end

  ##
  # Restringe a requisição a um administrador autenticado.
  #
  # Não recebe argumentos.
  #
  # Retorna +nil+; o resultado relevante é a continuidade ou interrupção da requisição.
  #
  # Efeitos colaterais: redireciona usuários não autorizados para o login e define um alerta.
  def require_admin!
    redirect_to login_path, alert: "Acesso restrito a administradores" unless current_admin
  end

  ##
  # Verifica se o usuário autenticado é administrador.
  #
  # Não recebe argumentos.
  #
  # Retorna +nil+ quando o acesso é permitido ou após preparar o redirecionamento.
  #
  # Efeitos colaterais: redireciona usuários não administradores para o painel e define um alerta.
  def require_admin
    return if user_signed_in? && current_user.admin?

    redirect_to root_path, alert: "Acesso restrito a administradores"
  end
end
