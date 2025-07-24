class User::TemplatesController < ApplicationController
  before_action :require_login
  before_action :set_template, only: [ :show, :respond ]

  def index
    # Mostrar templates que o usuário ainda não respondeu
    answered_template_ids = current_user.template_responses.pluck(:template_id)
    @available_templates = Template.where.not(id: answered_template_ids)
    @completed_templates = Template.joins(:template_responses)
                                   .where(template_responses: { user: current_user })
  end

  def show
    @response = @template.template_responses.find_or_initialize_by(user: current_user)
    @questions = @template.template_questions.ordered
  end

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

  def set_template
    @template = Template.find(params[:id])
  end
end
