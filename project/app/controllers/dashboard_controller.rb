##
# Exibe o painel inicial adequado ao papel do usuário autenticado.
class DashboardController < ApplicationController
  before_action :require_login

  ##
  # Renderiza o painel principal da aplicação.
  #
  # Não recebe argumentos.
  #
  # Retorna a resposta HTML construída pelo Rails.
  #
  # Efeitos colaterais: renderiza a view, que consulta os dados associados ao usuário atual.
  def show
  end
end
