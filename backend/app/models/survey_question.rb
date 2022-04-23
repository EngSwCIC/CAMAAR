class SurveyQuestion < ApplicationRecord
  belongs_to :survey
  has_many :answers, dependent: :destroy

  validates :question, uniqueness: { scope: :survey_id, message: 'Questão repetida!' }
  validates :category, inclusion: { in: ['Dissertativa', 'Escala', 'Caixa de Seleção'],
                                    message: ' - %<value>s não é um tipo válido de alternativa! '\
                                  'Escolha entre Dissertativa, Escala e Caixa de Seleção'  }
end
