# Controller base para a área administrativa. Aplica layout de admin e
# garante que apenas usuários autenticados com perfil de administrador
# possam acessar as rotas filhas.
class Admin::BaseController < ApplicationController
  layout 'admin'

  before_action :require_login
  before_action :require_admin

  private

  # Bloqueia o acesso de usuários sem perfil de administrador.
  #
  # Efeito colateral: redireciona para +root_path+ com alerta se o usuário
  # autenticado não for admin.
  def require_admin
    unless is_admin?
      redirect_to root_path, alert: "Acesso negado. Apenas administradores podem gerar este relatório."
    end
  end
end
