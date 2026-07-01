# Controller responsável pela sincronização de dados via API do SIGAA
class SigaaController < ApplicationController
  before_action :require_login
  before_action :require_admin

  # Inicia o processo de atualização do banco de dados chamando o serviço de sincronização
  #
  # Argumentos: Nenhum
  # Retorno: Nenhum
  # Efeitos Colaterais: Dispara o job de importação e redireciona com flash message.
  def update_database
    resultado = SigaaSyncService.new(current_user).call

    if resultado[:success]
      flash[:notice] = resultado[:message]
    else
      flash[:alert] = resultado[:message]
    end

    redirect_to home_path
  end
end