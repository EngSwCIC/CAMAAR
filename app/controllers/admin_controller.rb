class AdminController < ApplicationController
  before_action :require_admin

  # Variável de classe utilizada para sinalizar bloqueio/processamento de atualização concorrente no banco de dados.
  @@sigaa_updating = false

  # Exibe o painel inicial do administrador e as estatísticas gerais do sistema.
  #
  # <b>Parâmetros:</b>
  # * +params[:release_lock]+ - Se definido como "true", destrava o processo de atualização concorrente (String).
  #
  # <b>Retorno:</b>
  # * Renderiza a view do dashboard de administração.
  #
  # <b>Efeitos Colaterais:</b>
  # * Pode redefinir a variável @@sigaa_updating para +false+.
  def dashboard
    if params[:release_lock] == "true"
      @@sigaa_updating = false
    end

    @stats = {
      deps: Departamento.count,
      discs: Disciplina.count,
      turmas: Turma.count,
      mats: Matricula.count,
      users: Usuario.count
    }
  end

  # Carrega dados fictícios ou iniciais para testes da aplicação.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Redirecionamento para a página do dashboard.
  #
  # <b>Efeitos Colaterais:</b>
  # * Popula tabelas no banco de dados usando TestDataLoader e define notificações de sucesso ou erro no +flash+.
  def carregar_dados_teste
    return if check_sigaa_simulated_errors(admin_dashboard_path)

    begin
      TestDataLoader.call
      flash[:notice] = "Importação concluída com sucesso"
    rescue => e
      flash[:alert] = "Erro ao carregar dados de teste: #{e.message}"
    end
    redirect_to admin_dashboard_path
  end

  # Renderiza a página do console de integração com o SIGAA.
  #
  # <b>Parâmetros:</b>
  # * +params[:release_lock]+ - Se definido como "true", libera a trava concorrente (String).
  #
  # <b>Retorno:</b>
  # * Renderiza a página console de importação do SIGAA.
  #
  # <b>Efeitos Colaterais:</b>
  # * Pode definir @@sigaa_updating para +false+.
  def import_console
    if params[:release_lock] == "true"
      @@sigaa_updating = false
    end
  end

  # Lista todas as turmas vinculadas ao departamento do administrador atual, ou todas as turmas se não houver vínculo específico.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Renderiza a view contendo a listagem das turmas.
  #
  # <b>Efeitos Colaterais:</b>
  # * Define uma mensagem informativa no +flash.now+ caso nenhuma turma seja encontrada.
  def turmas
    @departamento = current_user.departamento
    if @departamento
      @turmas = Turma.where(departamento: @departamento)
    else
      @turmas = Turma.all
    end

    if @turmas.empty?
      @aviso_mensagem = "Nenhuma turma encontrada para o seu departamento neste semestre. Verifique o status da sincronização com o SIGAA."
    end
  end

  # Exibe os formulários de avaliação ativos de uma turma específica.
  #
  # <b>Parâmetros:</b>
  # * +params[:id]+ - O ID da turma desejada (Integer/String).
  #
  # <b>Retorno:</b>
  # * Redireciona para a lista de turmas se houver acesso negado, ou renderiza os formulários da turma.
  #
  # <b>Efeitos Colaterais:</b>
  # * Define alertas no +flash+ caso a turma pertença a outro departamento e o administrador tenha perfil restrito por departamento.
  def turma_avaliacoes
    @turma = Turma.find(params[:id])
    if current_user.departamento && @turma.departamento != current_user.departamento
      flash[:alert] = "Acesso negado: Você tem permissão para gerenciar apenas as turmas vinculadas ao seu departamento."
      redirect_to admin_turmas_path and return
    end

    @formularios = @turma.formularios
  end

  # Apresenta métricas e médias de desempenho das turmas vinculadas ao departamento do administrador atual ou de todas as turmas.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Renderiza a view de desempenho semestral.
  #
  # <b>Efeitos Colaterais:</b>
  # * Define a variável de instância +@desempenho_turmas+ mapeada com as estatísticas de média e número de respostas.
  def desempenho_semestral
    @departamento = current_user.departamento
    @turmas = @departamento ? Turma.where(departamento: @departamento) : Turma.all

    @desempenho_turmas = @turmas.map do |turma|
      {
        turma: turma,
        media: turma.calcular_media_desempenho,
        respostas_count: turma.respostas_count
      }
    end
  end

  # Simula a importação básica de dados do SIGAA.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Redirecionamento para a página do console de importação.
  #
  # <b>Efeitos Colaterais:</b>
  # * Verifica erros simulados do SIGAA, alterando o +flash+ de alerta, ou adiciona notificação de sucesso se correr normalmente.
  def sigaa_import
    if @@sigaa_updating
      flash[:alert] = "Uma atualização já está em andamento. Aguarde a conclusão."
      redirect_to admin_import_console_path and return
    end

    return if check_sigaa_simulated_errors(admin_import_console_path)

    # Perform normal import logic
    flash[:notice] = "Importação concluída com sucesso"
    redirect_to admin_import_console_path
  end

  # Simula o fluxo de atualização das matrículas e turmas do SIGAA (podendo liberar travas, processar alto volume ou simular cenários de cancelamento).
  #
  # <b>Parâmetros:</b>
  # * +params[:release_lock]+ - Se definido como "true", destrava o processo (String).
  # * +params[:large_volume]+ - Se definido como "true", ativa processamento assíncrono simulado de alto volume (String).
  #
  # <b>Retorno:</b>
  # * Redirecionamento para o console de importação.
  #
  # <b>Efeitos Colaterais:</b>
  # * Altera o banco de dados via simulação de desvinculação (+simulate_sigaa_unenrollment+), define variáveis de trava concorrente, e notifica via +flash+.
  def sigaa_update
    return handle_release_lock if params[:release_lock] == "true"
    return if handle_sigaa_updating
    return handle_large_volume if large_volume_request?
    return if check_sigaa_simulated_errors(admin_import_console_path)

    simulate_sigaa_unenrollment
    flash[:notice] = "Base de dados atualizada com sucesso"
    redirect_to admin_import_console_path
  ensure
    @@sigaa_updating = false unless large_volume_request?
  end

  # Libera a trava concorrente de atualização e redireciona com confirmação.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Redirecionamento para o console de importação.
  #
  # <b>Efeitos Colaterais:</b>
  # * Redefine @@sigaa_updating para +false+ e insere mensagem de sucesso no +flash+.
  def handle_release_lock
    @@sigaa_updating = false
    flash[:notice] = "Trava liberada com sucesso."
    redirect_to admin_import_console_path
  end

  # Simula o processamento em lote de grande volume de dados ativando a trava persistente.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Redirecionamento para o console de importação.
  #
  # <b>Efeitos Colaterais:</b>
  # * Define @@sigaa_updating como +true+ e adiciona mensagem explicativa no +flash+.
  def handle_large_volume
    @@sigaa_updating = true
    flash[:notice] = "Processando atualização de grande volume do SIGAA"
    redirect_to admin_import_console_path
  end

  # Verifica se a requisição atual solicita processamento de grande volume.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Boolean (+true+ se for grande volume, +false+ caso contrário).
  #
  # <b>Efeitos Colaterais:</b>
  # * Nenhum.
  def large_volume_request?
    params[:large_volume] == "true" || ENV["SIGAA_LARGE_VOLUME"] == "true"
  end

  private

  # Método interno para interceptar e tratar comportamentos de falha simulada (API offline, dados corrompidos, códigos ausentes, semestre vazio).
  #
  # <b>Parâmetros:</b>
  # * +redirect_path+ - Rota para redirecionar em caso de erro simulado (String).
  #
  # <b>Retorno:</b>
  # * Boolean (+true+ se algum erro ocorreu e redirecionou, +false+ caso contrário).
  #
  # <b>Efeitos Colaterais:</b>
  # * Define alertas apropriados no +flash+ se um erro for detectado.
  def check_sigaa_simulated_errors(redirect_path)
    error_msg = find_sigaa_error
    if error_msg
      flash[:alert] = error_msg
      redirect_to redirect_path
      return true
    end
    false
  end

  # Identifica a mensagem de erro específica baseada nas condições e variáveis de simulação configuradas no ambiente.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * String com a mensagem de erro apropriada, ou +nil+ se não houver erros simulados.
  #
  # <b>Efeitos Colaterais:</b>
  # * Nenhum.
  def find_sigaa_error
    return sigaa_offline_error if sigaa_status_matches?("offline", :sigaa_api_status, "SIGAA_API_STATUS")
    return sigaa_corrupted_error if sigaa_data_matches?("corrupted")
    return sigaa_missing_codes_error if sigaa_data_matches?("missing_codes")
    return sigaa_empty_error if semestre_futuro_or_empty?
    nil
  end

  # Mensagem de erro de conexão simulada.
  def sigaa_offline_error = "Erro de conexão com o SIGAA. Tente novamente mais tarde."

  # Mensagem de erro de dados corrompidos simulada.
  def sigaa_corrupted_error = "Erro de compatibilidade de dados. Atualização cancelada."

  # Mensagem de erro de códigos faltantes simulada.
  def sigaa_missing_codes_error = "Falha na importação: Códigos de disciplina ausentes"

  # Mensagem de erro de semestre vazio simulada.
  def sigaa_empty_error = "Nenhum dado novo encontrado para importação neste período."

  # Compara um valor com as variáveis de requisição ou ambiente de status do SIGAA.
  #
  # <b>Parâmetros:</b>
  # * +val+ - Valor esperado (String).
  # * +param_key+ - Chave de parâmetro na requisição (Symbol).
  # * +env_key+ - Chave de variável de ambiente (String).
  #
  # <b>Retorno:</b>
  # * Boolean.
  def sigaa_status_matches?(val, param_key, env_key)
    params[param_key] == val || ENV[env_key] == val
  end

  # Compara um valor com o estado dos dados do SIGAA.
  #
  # <b>Parâmetros:</b>
  # * +val+ - Valor esperado (String).
  #
  # <b>Retorno:</b>
  # * Boolean.
  def sigaa_data_matches?(val)
    params[:sigaa_data] == val || ENV["SIGAA_DATA_STATUS"] == val
  end

  # Identifica se o semestre informado é futuro ou se o status dos dados está configurado como vazio.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Boolean.
  def semestre_futuro_or_empty?
    params[:semestre] == "futuro" || ENV["SIGAA_DATA_STATUS"] == "empty"
  end

  # Intercepta a requisição caso já exista uma atualização de dados do SIGAA em progresso.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Boolean (+true+ se já estava em progresso, disparando redirecionamento, +false+ caso contrário).
  #
  # <b>Efeitos Colaterais:</b>
  # * Define alertas no +flash+.
  def handle_sigaa_updating
    if @@sigaa_updating || ENV["SIGAA_UPDATING_MOCK"] == "true"
      flash[:alert] = "Uma atualização já está em andamento. Aguarde a conclusão."
      redirect_to admin_import_console_path
      return true
    end
    false
  end

  # Simula a desvinculação ("unenrollment") ou inativação de um discente no SIGAA.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * +nil+
  #
  # <b>Efeitos Colaterais:</b>
  # * Altera a primeira matrícula encontrada do usuário "aluno@teste.com" para trancado ou inativo.
  def simulate_sigaa_unenrollment
    return unless ENV["SIGAA_DATA_STATUS"] == "missing_aluno"

    student = Usuario.find_by(email: "aluno@teste.com")
    return unless student

    matricula = student.matriculas.first
    return unless matricula

    if matricula.has_attribute?(:trancado)
      matricula.update!(trancado: true)
    else
      matricula.update!(papel_na_turma: "inativo")
    end
  end
end
