class AvaliacoesController < ApplicationController
  before_action :require_user
  before_action :set_formulario, only: [ :new, :create ]

  # Lista as pesquisas e avaliações pendentes ou respondidas baseadas no perfil do usuário atual.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Renderiza a listagem de avaliações.
  #
  # <b>Efeitos Colaterais:</b>
  # * Define as variáveis +@pesquisas_pendentes+ e +@pesquisas_respondidas+.
  def index
    case current_user.perfil
    when "administrador"
      load_admin_pesquisas
    when "docente"
      load_docente_pesquisas
    else
      load_discente_pesquisas
    end
  end

  # Exibe o formulário de avaliação para ser preenchido (new).
  #
  # <b>Parâmetros:</b>
  # * +params[:id]+ - O ID do formulário de avaliação (Integer/String).
  #
  # <b>Retorno:</b>
  # * Renderiza a página para responder à avaliação.
  #
  # <b>Efeitos Colaterais:</b>
  # * Define a variável +@formulario+ via before_action.
  def new
    # Already set by before_action
  end

  # Processa e salva as respostas submetidas pelo usuário para uma determinada avaliação.
  #
  # <b>Parâmetros:</b>
  # * +params[:id]+ - ID do formulário respondido (Integer/String).
  # * +params[:respostas]+ - Hash contendo as respostas fornecidas pelo usuário.
  #
  # <b>Retorno:</b>
  # * Redirecionamento para a lista de avaliações ou de volta para a resposta em caso de erros.
  #
  # <b>Efeitos Colaterais:</b>
  # * Cria um registro de +Resposta+ e os itens correspondentes (+RespostaItem+) associados no banco de dados. Define mensagens de erro/sucesso no +flash+.
  def create
    return if reject_duplicate_submission
    return if reject_missing_fields

    ActiveRecord::Base.transaction do
      @resposta = Resposta.create!(
        formulario: @formulario,
        usuario: current_user,
        enviado_em: Time.current
      )
      create_resposta_items
    end

    flash[:notice] = "Sua avaliação foi enviada com sucesso! Muito obrigado por contribuir."
    redirect_to avaliacoes_path
  rescue => e
    flash[:alert] = "Erro ao enviar avaliação: #{e.message}"
    redirect_to responder_avaliacao_path(@formulario)
  end

  private

  # Intercepta a submissão caso o usuário já tenha respondido anteriormente ao formulário.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Boolean (+true+ se já foi respondido e ocorreu redirecionamento, +false+ caso contrário).
  #
  # <b>Efeitos Colaterais:</b>
  # * Define alerta de duplicidade no +flash+ e redireciona para a lista de avaliações.
  def reject_duplicate_submission
    return false unless Resposta.exists?(formulario: @formulario, usuario: current_user)

    flash[:alert] = "Você já respondeu a este formulário"
    redirect_to avaliacoes_path
    true
  end

  # Intercepta a submissão caso existam perguntas obrigatórias sem resposta.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Boolean (+true+ se faltarem respostas e ocorreu redirecionamento, +false+ caso contrário).
  #
  # <b>Efeitos Colaterais:</b>
  # * Define mensagem de alerta de campos obrigatórios no +flash+ e redireciona para a tela do formulário.
  def reject_missing_fields
    return false unless missing_required_fields?

    flash[:alert] = "Preencha todos os campos obrigatórios"
    redirect_to responder_avaliacao_path(@formulario)
    true
  end

  # Carrega pesquisas para o perfil Administrador.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * +nil+
  #
  # <b>Efeitos Colaterais:</b>
  # * Preenche +@pesquisas_pendentes+ com todos os formulários abertos e +@pesquisas_respondidas+ com coleções vazias.
  def load_admin_pesquisas
    @pesquisas_pendentes = Formulario.where(status: "aberto")
    @pesquisas_respondidas = Formulario.none
  end

  # Carrega as pesquisas/avaliações associadas às turmas ministradas pelo docente logado.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * +nil+
  #
  # <b>Efeitos Colaterais:</b>
  # * Define as variáveis de instância correspondentes chamando +load_pesquisas_for+.
  def load_docente_pesquisas
    turmas = Turma.where(docente_id: current_user.id).pluck(:id)
    load_pesquisas_for(turmas, [ "docente", "docentes" ])
  end

  # Carrega as pesquisas/avaliações associadas às turmas em que o discente logado está matriculado.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * +nil+
  #
  # <b>Efeitos Colaterais:</b>
  # * Define as variáveis de instância correspondentes chamando +load_pesquisas_for+.
  def load_discente_pesquisas
    turmas = current_user.matriculas.pluck(:turma_id)
    load_pesquisas_for(turmas, [ "discente", "discentes" ])
  end

  # Carrega formulários ativos direcionados ao público-alvo específico para uma lista de turmas.
  #
  # <b>Parâmetros:</b>
  # * +turma_ids+ - Lista de IDs de turmas vinculadas (Array de Integers).
  # * +publico_alvo+ - Array de strings contendo as tags de público-alvo esperadas (Array de Strings).
  #
  # <b>Retorno:</b>
  # * +nil+
  #
  # <b>Efeitos Colaterais:</b>
  # * Preenche as variáveis de instância +@pesquisas_pendentes+ e +@pesquisas_respondidas+.
  def load_pesquisas_for(turma_ids, publico_alvo)
    now = Time.current
    answered_ids = current_user.respostas.pluck(:formulario_id)

    @pesquisas_pendentes = Formulario.where(
      turma_id: turma_ids,
      status: "aberto",
      publico_alvo: publico_alvo
    ).where("data_inicio <= ? AND data_limite >= ?", now, now)

    @pesquisas_respondidas = Formulario.where(id: answered_ids)
    @pesquisas_pendentes = @pesquisas_pendentes.where.not(id: answered_ids) if answered_ids.any?
  end

  # Verifica se alguma das perguntas obrigatórias do template não foi preenchida.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Boolean (+true+ se alguma pergunta obrigatória ficou em branco, +false+ caso contrário).
  #
  # <b>Efeitos Colaterais:</b>
  # * Nenhum.
  def missing_required_fields?
    @formulario.template.perguntas.each_with_index.any? do |pergunta, idx|
      pergunta.obrigatoria? && question_missing_answer?(pergunta, params.dig(:respostas, idx.to_s))
    end
  end

  # Determina se uma pergunta específica ficou sem resposta de acordo com seu tipo.
  #
  # <b>Parâmetros:</b>
  # * +pergunta+ - Instância do modelo +QuestaoTemplate+.
  # * +resp_param+ - Hash contendo os valores submetidos para a pergunta.
  #
  # <b>Retorno:</b>
  # * Boolean (+true+ se faltar a resposta, +false+ caso contrário).
  def question_missing_answer?(pergunta, resp_param)
    return true if resp_param.nil?

    if pergunta.tipo == "likert"
      resp_param[:nota].blank?
    else
      resp_param[:texto].blank?
    end
  end

  # Varre o template de perguntas e chama a persistência para cada item de resposta recebido.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * +nil+
  #
  # <b>Efeitos Colaterais:</b>
  # * Cria registros na tabela +resposta_itens+.
  def create_resposta_items
    @formulario.template.perguntas.each_with_index do |pergunta, idx|
      resp_param = params.dig(:respostas, idx.to_s)
      next if resp_param.nil? || question_missing_answer?(pergunta, resp_param)

      build_resposta_item(pergunta, resp_param)
    end
  end

  # Cria efetivamente um item de resposta (+RespostaItem+) no banco de dados.
  #
  # <b>Parâmetros:</b>
  # * +pergunta+ - Objeto +QuestaoTemplate+.
  # * +resp_param+ - Hash contendo as respostas dadas para a pergunta (+:nota+ e/ou +:texto+).
  #
  # <b>Retorno:</b>
  # * Objeto +RespostaItem+ criado e salvo.
  #
  # <b>Efeitos Colaterais:</b>
  # * Grava um novo registro de +RespostaItem+ associado a +@resposta+.
  def build_resposta_item(pergunta, resp_param)
    RespostaItem.create!(
      resposta: @resposta,
      questao_template: pergunta,
      valor_numerico: resp_param[:nota],
      valor_texto: resp_param[:texto],
      valor_opcao: resp_param[:nota].present? ? "Nota #{resp_param[:nota]}" : nil
    )
  end

  # Localiza e define o formulário atual a partir dos parâmetros de rota.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Objeto +Formulario+ encontrado.
  #
  # <b>Efeitos Colaterais:</b>
  # * Define a variável de instância +@formulario+.
  def set_formulario
    @formulario = Formulario.find(params[:id])
  end
end
