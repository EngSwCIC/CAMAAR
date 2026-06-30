class FormulariosController < ApplicationController
  before_action :require_admin

  # Renderiza a página para criação/distribuição de novos formulários de avaliação.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Renderiza a view contendo templates e turmas.
  #
  # <b>Efeitos Colaterais:</b>
  # * Inicializa +@templates+, +@turmas+ e um novo objeto +@formulario+.
  def new
    @templates = Template.all
    @turmas = Turma.all
    @formulario = Formulario.new
  end

  # Processa a criação de um único formulário (para uma turma específica) ou em lote (para múltiplas turmas).
  #
  # <b>Parâmetros:</b>
  # * +params[:formulario]+ - Hash com os parâmetros enviados pelo formulário de criação.
  #
  # <b>Retorno:</b>
  # * Redireciona para o dashboard ou renderiza a tela com erros de validação.
  #
  # <b>Efeitos Colaterais:</b>
  # * Cria um ou mais registros de +Formulario+ no banco de dados. Define mensagens de sucesso/erro no +flash+.
  def create
    form_params = extract_formulario_params

    if form_params[:turma_id].present?
      create_single(form_params)
    else
      create_batch(form_params)
    end
  end

  private

  # Extrai os parâmetros necessários para criação do formulário a partir da requisição.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Hash mapeado contendo os atributos tratados do formulário.
  def extract_formulario_params
    {
      publico_alvo: parse_publico_alvo,
      template_id: resolve_param(:template_id),
      status: resolve_param(:status) || "aberto",
      data_inicio: parse_time(resolve_param(:data_inicio)),
      data_limite: parse_time(resolve_param(:data_limite)),
      turma_id: resolve_param(:turma_id),
      turma_ids: params[:turma_ids]
    }
  end

  # Analisa e sanitiza o parâmetro do público-alvo.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * String contendo "discente", "docente" ou o valor original sanitizado.
  def parse_publico_alvo
    raw = resolve_param(:publico_alvo).to_s.downcase
    return "discente" if raw.include?("discente")
    return "docente" if raw.include?("docente")
    raw
  end

  # Resolve se o parâmetro está localizado no primeiro nível de chaves ou aninhado em +:formulario+.
  #
  # <b>Parâmetros:</b>
  # * +key+ - A chave de parâmetro desejada (Symbol).
  #
  # <b>Retorno:</b>
  # * O valor associado à chave ou +nil+.
  def resolve_param(key)
    params[key] || params[:formulario]&.[](key)
  end

  # Tenta converter uma string de data/tempo para um objeto Time válido.
  #
  # <b>Parâmetros:</b>
  # * +val+ - O valor a ser convertido.
  #
  # <b>Retorno:</b>
  # * Objeto +Time+ ou o valor original em caso de erro/vazio.
  def parse_time(val)
    return Time.parse(val) if val.is_a?(String) && val.present?
    val
  rescue StandardError
    val
  end

  # Cria um único formulário para uma turma específica.
  #
  # <b>Parâmetros:</b>
  # * +form_params+ - Hash de parâmetros higienizados.
  #
  # <b>Retorno:</b>
  # * Redirecionamento ou chamada para tratar o erro de persistência.
  #
  # <b>Efeitos Colaterais:</b>
  # * Salva um novo registro na tabela +formularios+ e define flash.
  def create_single(form_params)
    @formulario = Formulario.new(
      template: Template.find_by(id: form_params[:template_id]),
      turma_id: form_params[:turma_id],
      criado_por: current_user,
      publico_alvo: form_params[:publico_alvo],
      status: form_params[:status],
      data_inicio: form_params[:data_inicio],
      data_limite: form_params[:data_limite]
    )

    if @formulario.save
      flash[:notice] = "Formulário criado com sucesso!"
      redirect_to admin_dashboard_path
    else
      handle_single_creation_error
    end
  end

  # Define erros de validação e re-renderiza o formulário de criação unitária.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Renderiza a view +:new+ com status +:unprocessable_entity+.
  #
  # <b>Efeitos Colaterais:</b>
  # * Recarrega +@templates+ e +@turmas+. Adiciona erro ao +flash.now+.
  def handle_single_creation_error
    @templates = Template.all
    @turmas = Turma.all
    flash.now[:alert] = extract_validation_message
    render :new, status: :unprocessable_entity
  end

  # Extrai a mensagem descritiva de erro de validação.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * String com a mensagem de erro.
  def extract_validation_message
    formulario_error_message || @formulario.errors.full_messages.first
  end

  # Mapeia mensagens customizadas ou detalhadas sobre erros de negócio específicos.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * String de erro amigável ou +nil+.
  def formulario_error_message
    msgs = @formulario.errors.full_messages
    alvo_errs = @formulario.errors[:publico_alvo]
    return template_inativo_msg(msgs) if template_inativo_error?(msgs)
    return alvo_error_msg(alvo_errs) if alvo_errs.any?
    return discentes_msg(msgs) if msgs.any? { |m| m.include?("discentes vinculados") }
    return formulario_ativo_msg(msgs) if msgs.any? { |m| m.include?("Já existe um formulário ativo") }
    return "Datas de início e limite são obrigatórias" if dates_blank?
    nil
  end

  # Mensagem explicativa para template inativo.
  def template_inativo_msg(_msgs) = "Não é possível publicar formulários usando templates inativos"
  # Mensagem explicativa para ausência de discentes vinculados na turma.
  def discentes_msg(_msgs) = "Ação inválida: Esta turma ainda não possui discentes vinculados no SIGAA para responderem à avaliação."
  # Mensagem explicativa para conflito de formulários ativos simultâneos.
  def formulario_ativo_msg(_msgs) = "Atenção: Já existe um formulário ativo para os discentes desta turma. Encerre o atual antes de publicar um novo."

  # Processa e mapeia erros na definição de público alvo do formulário.
  #
  # <b>Parâmetros:</b>
  # * +errs+ - Lista de erros do campo de público alvo (Array de Strings).
  #
  # <b>Retorno:</b>
  # * String de erro amigável ou +nil+.
  def alvo_error_msg(errs)
    return "Obrigatório: Selecione se o formulário é destinado a docentes ou discentes." if errs.any? { |e| e.include?("Obrigatório") }
    return "Público alvo inválido ou muito longo" if errs.any? { |e| e.include?("muito longo") }
    nil
  end

  # Determina se alguma das datas obrigatórias está ausente.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Boolean.
  def dates_blank?
    @formulario.errors[:data_inicio].any? || @formulario.errors[:data_limite].any?
  end

  # Determina se houve falha de validação gerada pelo uso de template inativo.
  #
  # <b>Parâmetros:</b>
  # * +msgs+ - Lista completa de erros do formulário (Array de Strings).
  #
  # <b>Retorno:</b>
  # * Boolean.
  def template_inativo_error?(msgs)
    @formulario.errors[:template_id].any? { |e| e.include?("templates inativos") } ||
      msgs.any? { |m| m.include?("templates inativos") }
  end

  # Dispara a criação e distribuição de formulários em lote (batch).
  #
  # <b>Parâmetros:</b>
  # * +form_params+ - Hash de parâmetros de formulário.
  #
  # <b>Retorno:</b>
  # * Redirecionamento de rotas.
  #
  # <b>Efeitos Colaterais:</b>
  # * Cria múltiplos registros na tabela +formularios+.
  def create_batch(form_params)
    return redirect_no_turmas if form_params[:turma_ids].blank?

    template = Template.find_by(id: form_params[:template_id])
    errors, created_count = run_batch_transaction(template, form_params)
    handle_batch_result(errors, created_count, template)
  end

  # Redireciona e alerta o usuário caso tente disparar em lote sem selecionar turmas.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Redireciona para a tela de novo formulário.
  #
  # <b>Efeitos Colaterais:</b>
  # * Insere alerta no +flash+.
  def redirect_no_turmas
    flash[:alert] = "Selecione pelo menos uma turma para distribuir os formulários."
    redirect_to new_formulario_path
  end

  # Executa a transação para criação em lote de formulários de maneira atômica.
  #
  # <b>Parâmetros:</b>
  # * +template+ - Instância do modelo +Template+.
  # * +form_params+ - Hash de parâmetros dos formulários.
  #
  # <b>Retorno:</b>
  # * Array no formato +[errors_array, created_count_integer]+.
  #
  # <b>Efeitos Colaterais:</b>
  # * Realiza rollback completo caso qualquer um dos formulários do lote falhe na validação.
  def run_batch_transaction(template, form_params)
    errors = []
    created_count = 0
    ActiveRecord::Base.transaction do
      form_params[:turma_ids].each do |t_id|
        form = build_batch_formulario(template, t_id, form_params)
        form.save ? (created_count += 1) : (errors << form.errors.full_messages.first; raise ActiveRecord::Rollback)
      end
    end
    [ errors, created_count ]
  end

  # Inicializa uma instância de formulário com os valores customizados ou defaults do lote.
  #
  # <b>Parâmetros:</b>
  # * +template+ - Instância do modelo +Template+.
  # * +t_id+ - ID da turma (Integer/String).
  # * +form_params+ - Hash de parâmetros originais.
  #
  # <b>Retorno:</b>
  # * Nova instância não persistida de +Formulario+.
  def build_batch_formulario(template, t_id, form_params)
    Formulario.new(
      template: template,
      turma_id: t_id,
      criado_por: current_user,
      publico_alvo: form_params[:publico_alvo] || template&.perfil_alvo || "discente",
      status: form_params[:status],
      data_inicio: form_params[:data_inicio] || Time.current,
      data_limite: form_params[:data_limite] || (Time.current + 7.days)
    )
  end

  # Trata e notifica o resultado final da execução do lote de formulários.
  #
  # <b>Parâmetros:</b>
  # * +errors+ - Array contendo strings com mensagens de erros ocorridos.
  # * +created_count+ - Quantidade de formulários criados (Integer).
  # * +template+ - Instância do modelo +Template+ utilizado.
  #
  # <b>Retorno:</b>
  # * Redirecionamento de rotas.
  #
  # <b>Efeitos Colaterais:</b>
  # * Define mensagens de aviso/sucesso no +flash+.
  def handle_batch_result(errors, created_count, template)
    if errors.any?
      flash[:alert] = "Erro ao disparar formulários: #{errors.join(', ')}"
      redirect_to new_formulario_path
    else
      flash[:notice] = "Formulário '#{template&.titulo}' disparado para #{created_count} turmas com sucesso!"
      redirect_to admin_dashboard_path
    end
  end
end
