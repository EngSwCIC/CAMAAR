# Controller responsável pelo processo de autenticação (login/logout) de usuários.
#
# Ele lida com:
# - Exibição do formulário de login
# - Autenticação de credenciais
# - Encerramento de sessão (logout)
class LoginController < ApplicationController
  # Action para exibir o formulário de login
  #
  # GET /login
  #
  # Renderiza a view 'login/index.html.erb' que deve conter o formulário de login.
  layout 'login'
  def index
  end

end