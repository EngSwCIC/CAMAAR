##
# Resposta individual para uma pergunta específica
#
# Armazena a resposta de um usuário para uma pergunta individual dentro
# de um template. O formato da resposta depende do tipo da pergunta.
#
# === Formatos de Resposta por Tipo
# * +text+: Texto livre digitado pelo usuário
# * +radio+: Valor da opção selecionada
# * +checkbox+: Valores separados por vírgula das opções marcadas
# * +scale+: Número de 1 a 5 representando a escala
#
# === Associações
# * Pertence a um TemplateResponse (conjunto de respostas do usuário)
# * Pertence a um TemplateQuestion (pergunta sendo respondida)
#
# === Exemplo de uso
#
#   # Resposta de texto
#   answer = response.question_answers.create!(
#     template_question: text_question,
#     answer_text: "Ótima disciplina, aprendi muito!"
#   )
#
#   # Resposta de escala
#   answer = response.question_answers.create!(
#     template_question: scale_question,
#     answer_text: "5"
#   )
#
#   # Resposta de múltipla escolha
#   answer = response.question_answers.create!(
#     template_question: radio_question,
#     answer_text: "Concordo Totalmente"
#   )
#
class QuestionAnswer < ApplicationRecord
  belongs_to :template_response
  belongs_to :template_question

  ##
  # Garante uma resposta por pergunta dentro de cada template_response
  validates :template_response_id, uniqueness: { scope: :template_question_id }
end
