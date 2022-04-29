##
# Essa classe representa o model ActiveRecord que armazena respostas a cada pergunta do tipo LikertQuestion de um questionário

class LikertAnswer < ApplicationRecord
  belongs_to :answer
  belongs_to :likert_question

  validate :required_questions_answered

  private 

  ##
  # Valida se a resposta para uma pergunta +LikertQuestion+ obrigatória possui conteúdo.
  #
  # É chamada durante a execução do método +LikertAnswer::save+.
  #
  # Adiciona um erro ao model caso a pergunta seja obrigatória e o conteúdo seja nulo.

  def required_questions_answered
    errors.add(:content, 'is missing') if not answer&.survey_question&.optional and content.nil?
  end
end
