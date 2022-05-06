##
# Essa classe representa o model ActiveRecord que armazena respostas a cada pergunta de um questionário

class Answer < ApplicationRecord
  belongs_to :survey_answer
  belongs_to :survey_question
  has_many :likert_answers, dependent: :destroy
  accepts_nested_attributes_for :likert_answers

  validate :required_questions_answered

  private 

  ##
  # Valida se a resposta para uma pergunta obrigatória possui conteúdo.
  #
  # É chamada durante a execução do método Answer::save.
  #
  # Adiciona um erro ao model caso a pergunta seja obrigatória e o conteúdo seja nulo.

  def required_questions_answered
    if question_type != 'likert_scale'
      if !survey_question&.optional and content.nil?
        errors.add(:content, 'is missing') 
      end
    end
  end
end
