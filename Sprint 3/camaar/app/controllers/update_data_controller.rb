
# Responsável por receber as requisições de atualização de dados do SIGAA
# e delegar o processamento para o UpdateDataService.
#
# Todas as actions exigem autenticação e perfil de administrador.
class UpdateDataController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  layout 'authenticated'
 
  # Dispara a atualização dos dados do SIGAA na base existente.
  #
  # Não recebe argumentos. Chama UpdateDataService.update_all e
  # possui duas possibilidades de retorno:
  # - Redireciona para dashboard_path com a mensagem do serviço
  #   (dados atualizados ou já sincronizados) quando bem-sucedido;
  # - Redireciona para dashboard_path com alerta de erro quando
  #   os arquivos não são encontrados ou o JSON é inválido.
  # Efeito colateral: pode atualizar registros de +Disciplina+, +Turma+
  # e User no banco de dados em caso de alterações detectadas.
  def update
    result = UpdateDataService.update_all
 
    if result[:success]
      redirect_to dashboard_path, notice: result[:message]
    else
      redirect_to dashboard_path, alert: result[:error]
    end
  end
end