# Responsável por receber as requisições de importação de dados do SIGAA
# e delegar o processamento para o ImportDataService.
#
# Todas as actions exigem autenticação e perfil de administrador.
class ImportDataController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  layout 'authenticated'
 
  # Dispara a importação completa dos dados do SIGAA.
  #
  # Não recebe argumentos. Chama ImportDataService.import_all e
  # possui duas possibilidades de retorno:
  # - Redireciona para dashboard_path com notice de sucesso quando
  #   a importação é concluída;
  # - Redireciona para dashboard_path com alerta de erro quando
  #   os arquivos não são encontrados ou o JSON é inválido.
  # Efeito colateral: pode persistir registros de Disciplina, Turma,
  # User e TurmaAluno no banco de dados em caso de sucesso.
  def import
    result = ImportDataService.import_all
 
    if result[:success]
      redirect_to dashboard_path, notice: 'Dados importados com sucesso.'
    else
      redirect_to dashboard_path, alert: result[:error]
    end
  end
 
end
 