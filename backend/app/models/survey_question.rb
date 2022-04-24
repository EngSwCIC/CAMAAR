class SurveyQuestion < ApplicationRecord
  belongs_to :survey
  has_many :answers, dependent: :destroy
  has_many :options, dependent: :destroy

  validates :question, uniqueness: { scope: :survey_id, message: 'Questão repetida!' }
  validates :question_type, inclusion: { in: ['Dissertativa', 'Escala', 'Caixa de Seleção'],
                                    message: ' - %<value>s não é um tipo válido de alternativa! '\
                                  'Escolha entre Dissertativa, Escala e Caixa de Seleção'  }

  validates :optional, inclusion: {in: [true, false], 
                                      message: ' - %<value>s não é um tipo válido de alternativa! '\
                                      'Escolha entre Dissertativa, Escala e Caixa de Seleção'  }
end
