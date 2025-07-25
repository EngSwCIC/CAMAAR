##
# Controller para usuários responderem templates de avaliação
#
# Permite que usuários comuns (docentes e discentes) visualizem templates
# disponíveis, respondam formulários e acompanhem progresso de respostas.
#
# === Público-alvo
# * Docentes: Podem responder avaliações institucionais
# * Discentes: Podem responder avaliações de disciplinas
# * Admins: Redirecionados para área administrativa
#
# === Funcionalidades
# * Listagem de templates pendentes e concluídos
# * Formulário de resposta para templates
# * Submissão de respostas com validação
# * Prevenção de respostas duplicadas
#
# === Rotas
#   GET   /user/templates           # index - listagem
#   GET   /user/templates/:id       # show - formulário
#   PATCH /user/templates/:id/respond # respond - submissão
#
class User::TemplatesController < ApplicationController
  before_action :require_login
  before_action :set_template, only: [ :show, :respond ]

  ##
  # Lista templates disponíveis e concluídos para o usuário
  #
  # Separa templates em duas categorias para melhor UX:
  # * Pendentes: Templates ainda não respondidos
  # * Concluídos: Templates já respondidos pelo usuário
  #
  # === Variáveis de instância
  # +@available_templates+:: Templates não respondidos pelo usuário
  # +@completed_templates+:: Templates já respondidos pelo usuário
  #
  # === Lógica de Filtros
  # * Busca IDs de templates já respondidos
  # * Filtra templates disponíveis excluindo os já respondidos
  # * Carrega templates concluídos via JOIN com respostas
  def index
    # Mostrar templates que o usuário ainda não respondeu
    answered_template_ids = current_user.template_responses.pluck(:template_id)
    @available_templates = Template.where.not(id: answered_template_ids)
    @completed_templates = Template.joins(:template_responses)
                                   .where(template_responses: { user: current_user })
  end

  ##
  # Exibe formulário de resposta para um template específico
  #
  # Carrega template com perguntas ordenadas e inicializa resposta do usuário.
  # Se usuário já respondeu, pode visualizar mas não re-submeter.
  #
  # === Variáveis de instância
  # +@template+:: Template sendo respondido
  # +@response+:: TemplateResponse existente ou novo
  # +@questions+:: Perguntas ordenadas por posição
  #
  # === Comportamento
  # * Cria nova resposta se não existe
  # * Recupera resposta existente se já iniciada
  # * Ordena perguntas por campo position
  def show
    @response = @template.template_responses.find_or_initialize_by(user: current_user)
    @questions = @template.template_questions.ordered
  end

  ##
  # Processa submissão de respostas para um template
  #
  # Salva respostas individuais para cada pergunta e marca como concluída.
  # Implementa validação básica e prevenção de submissões vazias.
  #
  # === Parâmetros esperados
  # +answers+:: Hash com question_id => answer_text
  #
  # === Processo de Salvamento
  # 1. Cria/recupera TemplateResponse
  # 2. Itera sobre respostas fornecidas
  # 3. Cria/atualiza QuestionAnswer para cada pergunta
  # 4. Marca resposta como submetida (submitted_at)
  #
  # === Responses
  # * Sucesso: Redirect para user_templates_path com notice
  # * Falha: Redirect de volta com alert de erro
  def respond
    @response = @template.template_responses.find_or_initialize_by(user: current_user)

    # Salvar respostas
    if params[:answers].present?
      @response.save! if @response.new_record?

      params[:answers].each do |question_id, answer_text|
        next if answer_text.blank?

        question = @template.template_questions.find(question_id)
        answer = @response.question_answers.find_or_initialize_by(template_question: question)
        answer.answer_text = answer_text
        answer.save!
      end

      @response.update!(submitted_at: Time.current)
      redirect_to user_templates_path, notice: "Respostas enviadas com sucesso!"
    else
      redirect_to user_template_path(@template), alert: "Por favor, responda pelo menos uma pergunta."
    end
  end

  private

  ##
  # Carrega template específico para ações que requerem
  #
  # Diferente do admin controller, não filtra por owner pois usuários
  # precisam acessar templates criados por admins.
  def set_template
    @template = Template.find(params[:id])
  end
end
