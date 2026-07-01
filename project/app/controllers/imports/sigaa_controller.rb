##
# Agrupa os controllers responsáveis por importar dados de sistemas externos.
module Imports
  ##
  # Coordena pela interface administrativa a sincronização de turmas e participantes
  # a partir dos arquivos exportados pelo SIGAA.
  class SigaaController < ApplicationController
    before_action :require_admin

    ##
    # Exibe o formulário de sincronização e os semestres disponíveis nos arquivos de origem.
    #
    # Não recebe argumentos explícitos; pode utilizar +params[:semester]+.
    #
    # Retorna a resposta HTML construída pelo Rails.
    #
    # Efeitos colaterais: lê os arquivos JSON e define +@semesters+ e +@semester+ para a view.
    def new
      @semesters = Sigaa::DataSynchronizer.available_semesters
      @semester = params[:semester].presence || @semesters.first
    end

    ##
    # Executa a sincronização dos dados do SIGAA para o semestre selecionado.
    #
    # Não recebe argumentos explícitos; utiliza os parâmetros permitidos da requisição.
    #
    # Retorna uma resposta de redirecionamento para a tela de importação.
    #
    # Efeitos colaterais: cria ou atualiza registros, pode enviar e-mails e define uma
    # mensagem com o resultado da sincronização.
    def create
      result = Sigaa::DataSynchronizer.new(semester: sync_params[:semester], imported_by: current_user).call

      if result.already_up_to_date?
        redirect_to imports_sigaa_path, notice: "A base de dados já está atualizada com o SIGAA para este período."
      else
        redirect_to imports_sigaa_path,
          notice: "Sincronização concluída. #{result.created_count} novos registros adicionados e #{result.updated_count} registros atualizados."
      end
    end

    private

    ##
    # Filtra o período letivo aceito pela ação de sincronização.
    #
    # Não recebe argumentos explícitos; lê +params[:sigaa_sync]+.
    #
    # Retorna ActionController::Parameters contendo apenas +semester+.
    #
    # Efeitos colaterais: pode lançar ActionController::ParameterMissing quando a chave
    # obrigatória não estiver presente.
    def sync_params
      params.require(:sigaa_sync).permit(:semester)
    end
  end
end
