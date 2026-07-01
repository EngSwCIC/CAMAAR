# Verifica e disponibiliza o administrador autenticado referenciado pela rota.
#
# Redireciona para a página inicial com alerta se o administrador da rota for
# diferente do usuário autenticado na sessão.
module AdminAutenticavel
  extend ActiveSupport::Concern

  private

  # Busca e valida o administrador referenciado pela rota.
  #
  # @return [void]
  def set_admin
    @admin = Administrador.find(params[:admin_id])

    if @admin.id != session[:usuario_id]
      redirect_to inicio_path, alert: "Acesso negado! Você só pode acessar as suas próprias páginas."
    end
  end
end
