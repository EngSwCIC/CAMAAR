# Gerencia as funcionalidades exclusivas do administrador do sistema.
#
# Agrupa as ações restritas ao perfil +Administrador+: visualização e exportação
# de avaliações, envio de formulários a turmas a partir de templates, tela de
# gerenciamento geral e sincronização de dados com o SIGAA (importação e
# atualização via arquivos JSON). Utiliza o layout "gerenciamento" e valida
# que o administrador autenticado acessa apenas as suas próprias páginas.
class AdminController < ApplicationController
  layout "gerenciamento"

  before_action :require_login
  before_action :require_admin
  before_action :set_admin

  include AdminAutenticavel

  SINCRONIZACAO_HANDLERS = {
    "importar" => ->(cp, cm) { SigaaImporter.import_from_files(cp, cm) },
    "atualizar" => ->(cp, cm) { SigaaImporter.update_from_files(cp, cm) }
  }.freeze

  MENSAGENS_SINCRONIZACAO = {
    "importar" => {
      parcial: "alguns dados já foram importados e não serão importados novamente, mas os dados restantes serão importados com sucesso",
      sucesso: "As turmas, matérias e participantes do SIGAA estão presentes no sistema.",
      nome_acao: "importação"
    },
    "atualizar" => {
      parcial: "alguns dados já estão atualizados e não serão atualizados novamente, mas os dados restantes serão atualizados com sucesso",
      sucesso: "As turmas, matérias e participantes do SIGAA estão atualizados no sistema com os dados atuais do SIGAA.",
      nome_acao: "atualização"
    }
  }.freeze

  # Lista todos os formulários com suas turmas, disciplinas, departamentos e docentes.
  #
  # @return [void]
  def avaliacoes
    @avaliacoes = Formulario
      .joins(:turma)
      .includes(turma: { disciplina: :departamento, docentes: [] })
  end

  # Exibe a página de gerenciamento do administrador.
  #
  # @return [void]
  def gerenciamento
  end

  # Exibe o formulário de envio de avaliações (GET) ou cria formulários a partir de um
  # template para as turmas selecionadas (POST).
  #
  # @return [void]
  # @note GET: popula +@templates+ e +@turmas+ para exibição do formulário de seleção.
  #   POST: delega a criação dos formulários para +processar_envio_formularios+.
  def enviar_formularios
    if request.get?
      @templates = Template.where(usuario_id: @admin.id)
      @turmas = Turma.joins(:disciplina).includes(:disciplina).order("disciplinas.nome, turmas.semestre")
    elsif request.post?
      processar_envio_formularios
    end
  end

  # Lista os formulários pertencentes às disciplinas do departamento do administrador.
  #
  # @return [void]
  def resultados
    @formularios = Formulario.joins(turma: :disciplina).where(disciplinas: { departamento_id: @admin.departamento_id }).includes(turma: :disciplina)
  end

  # Exporta as respostas de um formulário como arquivo CSV para download.
  #
  # @return [void]
  # @note Lê o parâmetro +:id+ da rota. Redireciona com alerta se o formulário não for
  #   encontrado ou não possuir respostas. Em caso de sucesso, força o download do CSV.
  def exportar_csv
    @formulario = Formulario.find_by(id: params[:id])

    unless @formulario
      redirect_to admin_resultados_path(@admin), alert: "Formulário não encontrado"
      return
    end

    @respostas = RespostaForm.where(formulario_id: @formulario.id).includes(:usuario, resposta_elems: :elemento_form)

    if @formulario.resposta_forms.empty?
      redirect_to admin_resultados_path(@admin), alert: "Falha na exportação: Este formulário ainda não possui respostas registradas."
      return
    end

    respond_to do |format|
      format.csv { definir_headers_csv }
    end
  end

  # Exibe a página de sincronização com o SIGAA (GET) ou processa a sincronização (POST).
  #
  # @return [void]
  def sincronizar_sigaa
    if request.get?
      render :sincronizar_sigaa
    elsif request.post?
      processar_sincronizacao
    end
  end

  private

  # Valida os parâmetros e cria formulários a partir de um template para as turmas selecionadas.
  #
  # @return [void]
  def processar_envio_formularios
    template_id = params[:template_id]
    turma_ids = params[:turma_ids]
    envio_path = admin_enviar_formularios_path(@admin)

    if template_id.blank?
      redirect_to envio_path, alert: "Selecione um template para criar o formulário"
      return
    end

    if turma_ids.blank?
      redirect_to envio_path, alert: "Selecione pelo menos uma turma"
      return
    end

    template = Template.includes(elementos: :campos).find(template_id)
    Turma.where(id: turma_ids).each { |turma| criar_formulario_para_turma(template, turma) }

    msg = turma_ids.size == 1 ? "Formulário criado com sucesso" : "Formulários criados com sucesso"
    flash[:notice] = msg
    redirect_to admin_gerenciamento_path(@admin)
  end

  # Cria um formulário para uma turma a partir de um template, copiando seus elementos.
  #
  # @param template [Template] template de origem
  # @param turma [Turma] turma destinatária
  # @return [void]
  def criar_formulario_para_turma(template, turma)
    formulario = Formulario.create!(
      turma: turma,
      titulo: "#{turma.disciplina.nome} - #{turma.semestre}"
    )
    template.elementos.each { |elemento| copiar_elemento(elemento, formulario) }
  end

  # Copia um elemento de template para um formulário, incluindo seus campos se não for texto livre.
  #
  # @param elemento [Elemento] elemento do template de origem
  # @param formulario [Formulario] formulário de destino
  # @return [void]
  def copiar_elemento(elemento, formulario)
    campos = elemento.campos
    tipo = campos.first&.tipo_elemento || "Texto"
    ef = formulario.elemento_forms.create!(
      enunciado: elemento.enunciado,
      ordem: elemento.ordem,
      tipo: tipo
    )
    return if tipo == "Texto"

    campos.each do |campo|
      ef.campo_forms.create!(enunciado: campo.enunciado, ordem: campo.ordem)
    end
  end

  # Define os cabeçalhos HTTP para o download do CSV do formulário.
  #
  # @return [void]
  def definir_headers_csv
    turma = @formulario.turma
    num_turma = turma&.numero_da_turma&.parameterize(separator: "_") || "sem_turma"
    nome_materia = turma&.disciplina&.nome&.parameterize(separator: "_") || "sem_materia"
    nome_arquivo = "formulario_#{@formulario.id}_turma_#{num_turma}_#{nome_materia}.csv"
    response.headers["Content-Disposition"] = "attachment; filename=\"#{nome_arquivo}\""
  end

  # Lê os arquivos enviados via POST e delega ao handler adequado do SigaaImporter.
  #
  # @return [void]
  def processar_sincronizacao
    arquivo_classes = params[:arquivo_classes]
    arquivo_membros = params[:arquivo_membros]

    unless arquivo_classes.present? && arquivo_membros.present?
      redirect_to admin_gerenciamento_path, alert: "Por favor, selecione os dois arquivos JSON"
      return
    end

    acao = params[:acao]
    handler = SINCRONIZACAO_HANDLERS[acao]
    resultado = handler ? handler.call(arquivo_classes.path, arquivo_membros.path) : "ação inválida"
    processar_resultado(resultado, acao)
  end

  # Redireciona para a página de gerenciamento com mensagem apropriada ao resultado da sincronização.
  #
  # @param resultado [String] mensagem retornada pelo +SigaaImporter+
  # @param acao [String] "importar" ou "atualizar"
  # @return [void]
  def processar_resultado(resultado, acao)
    msgs = MENSAGENS_SINCRONIZACAO.fetch(acao, { parcial: "", sucesso: "", nome_acao: acao.to_s })
    gerenciamento = admin_gerenciamento_path(@admin)

    case resultado
    when /alguns dados/i
      redirect_to gerenciamento, notice: msgs[:parcial]
    when /sucesso/i
      redirect_to gerenciamento, notice: msgs[:sucesso]
    when /já existem/i
      redirect_to gerenciamento, alert: "os dados do SIGAA já existem na base de dados do sistema e não serão importados novamente"
    when /já estão atualizados/i
      redirect_to gerenciamento, alert: "os dados do SIGAA já estão atualizados e não serão atualizados novamente"
    else
      redirect_to gerenciamento, alert: "erro informando que a #{msgs[:nome_acao]} falhou"
    end
  end
end
