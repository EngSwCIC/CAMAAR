# Controller base da aplicação do qual todos os demais controllers herdam.
#
# Define os helpers e filtros de autenticação e autorização compartilhados:
# +current_user+ (disponível nas views via +helper_method+), +require_login+
# (exige sessão ativa) e +require_admin+ (exige perfil de administrador).
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user

  # Retorna o usuário atualmente autenticado na sessão.
  #
  # @return [Usuario, nil] instância do usuário logado, ou +nil+ se não houver sessão ativa
  def current_user
    @current_user ||= Usuario.find_by(id: session[:usuario_id])
  end

  # Exige que o usuário esteja autenticado para acessar a ação.
  #
  # @return [void]
  # @note Redireciona para a página raiz com alerta caso o usuário não esteja logado.
  def require_login
    unless current_user
      redirect_to root_path, alert: "Você precisa estar logado para acessar esta página."
    end
  end

  # Exige que o usuário autenticado seja um administrador.
  #
  # @return [void]
  # @note Redireciona para a página inicial com alerta caso o usuário não seja um +Administrador+.
  def require_admin
    unless current_user.is_a?(Administrador)
      redirect_to inicio_path, alert: "Acesso negado."
    end
  end
end
