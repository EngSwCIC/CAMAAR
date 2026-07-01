# Serviço para sincronizar dados do SIGAA
class SigaaSyncService
  # Inicializa o servico
  #
  # Argumentos: user (User)
  # Retorno: Nenhum
  # Efeitos Colaterais: Salva user no estado
  def initialize(user)
    @user = user
  end

  # Inicia o processo de importacao
  #
  # Argumentos: Nenhum
  # Retorno: Hash com status e message
  # Efeitos Colaterais: Cria locks, importa turmas e membros, registra logs.
  def call
    return failure("Acesso negado") unless @user.admin?
    return failure("Já existe uma atualização em andamento") if SyncLock.active?

    SyncLock.start!
    execute_sync
  ensure
    SyncLock.release!
  end

  private

  # Executa o sincronismo real
  #
  # Argumentos: Nenhum
  # Retorno: Hash com sucesso ou falha
  # Efeitos Colaterais: Importa turmas ou captura exceções
  def execute_sync
    begin
      json = SigaaApi.fetch_data
      return failure("SIGAA não retornou dados") if json.nil? || json.strip == "[]"

      import_data_from_json(json)
    rescue => e
      log_sync_event("error", e.message)
      failure(e.message)
    end
  end

  # Coordena as chamadas para o importador
  #
  # Argumentos: json (String)
  # Retorno: Hash
  # Efeitos Colaterais: Persistencia no DB
  def import_data_from_json(json)
    classes = SigaaImporter.import_classes(json)
    members = SigaaImporter.import_members(json)

    if classes[:success] && members[:success]
      log_sync_event("success", "Atualização SIGAA concluída")
      success("Atualização concluída com sucesso")
    else
      failure("SIGAA retornou dados inconsistentes")
    end
  end

  # Salva log da operacao
  #
  # Argumentos: status, message
  # Retorno: Nenhum
  # Efeitos Colaterais: Salva SigaaLog no DB
  def log_sync_event(status, message)
    SigaaLog.create!(
      user: @user,
      status: status,
      message: message
    )
  end

  # Auxiliar de sucesso
  #
  # Argumentos: msg
  # Retorno: Hash
  # Efeitos Colaterais: Nenhum
  def success(msg)
    { success: true, message: msg }
  end

  # Auxiliar de falha
  #
  # Argumentos: msg
  # Retorno: Hash
  # Efeitos Colaterais: Nenhum
  def failure(msg)
    { success: false, message: msg }
  end
end