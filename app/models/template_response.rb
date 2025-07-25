##
# Resposta completa de um usuário a um template
#
# Representa o conjunto de todas as respostas de um usuário específico
# para um template específico. Cada usuário pode responder apenas uma vez
# por template.
#
# === Estado da Resposta
# Uma resposta pode estar em dois estados:
# * +Em andamento+: submitted_at é nil (rascunho)
# * +Concluída+: submitted_at preenchido (finalizada)
#
# === Associações
# * Pertence a um User (quem respondeu)
# * Pertence a um Template (template respondido)
# * Tem muitas QuestionAnswer (respostas individuais para cada pergunta)
#
# === Exemplo de uso
#
#   # Iniciar nova resposta
#   response = template.template_responses.build(user: current_user)
#   response.save!
#
#   # Adicionar respostas às perguntas
#   template.template_questions.each do |question|
#     response.question_answers.create!(
#       template_question: question,
#       answer_text: user_input[question.id]
#     )
#   end
#
#   # Finalizar resposta
#   response.update!(submitted_at: Time.current)
#
class TemplateResponse < ApplicationRecord
  belongs_to :user
  belongs_to :template
  has_many :question_answers, dependent: :destroy

  ##
  # Garante que cada usuário responda apenas uma vez por template
  validates :user_id, uniqueness: { scope: :template_id }

  ##
  # Verifica se a resposta foi finalizada
  #
  # === Retorno
  # +Boolean+:: true se submitted_at está preenchido
  #
  # === Exemplo
  #   if response.complete?
  #     # Mostrar como "Respondido"
  #   else
  #     # Permitir continuar editando
  #   end
  def complete?
    submitted_at.present?
  end

  ##
  # Busca a resposta para uma pergunta específica
  #
  # === Parâmetros
  # +question+:: TemplateQuestion para buscar a resposta
  #
  # === Retorno
  # +QuestionAnswer+:: Resposta para a pergunta ou nil
  #
  # === Exemplo
  #   answer = response.answer_for_question(question)
  #   puts answer.answer_text if answer
  def answer_for_question(question)
    question_answers.find_by(template_question: question)
  end
end
