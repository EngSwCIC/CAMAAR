# Exibe a página inicial da aplicação após o login.
#
# Requer que o usuário esteja autenticado. Serve como ponto de entrada genérico
# após o redirecionamento pós-login, quando o perfil do usuário ainda não foi
# determinado pelo +SessionsController+.
class HomeController < ApplicationController
  before_action :require_login

  # Exibe a página inicial da aplicação.
  #
  # @return [void]
  def index
  end
end
