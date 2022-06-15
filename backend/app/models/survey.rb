##
# Essa classe representa o model ActiveRecord que armazena o questionário que será 
# respondido pelos membros do corpo dicente para cada Cclass em que estão matriculados

class Survey < ApplicationRecord
  belongs_to :role
  has_many :survey_answers
  has_many :survey_questions, dependent: :destroy
  accepts_nested_attributes_for :survey_questions

  validates :name, :description, :expiration_date, :semester, presence: true

  ##
  # Método que verifica se a um +Survey+ está fora da validade.
  #
  # Retorna +true+ caso +expiration_date+ seja _menor_ que a data atual e
  # retorna +false+ caso +expiration_date+ seja _maior_ que a data atual.
  def is_expired?
    self.expiration_date <= DateTime.now
  end

  ##
  # Método que sobrescreve funcionalidade padrão de +as_json+ do +ActiveRecord+
  # a fim de incluir atributos de +SurveyQuestions+, +MultipleChoice+, +Options+,
  # +LikertScale+ e +LikertQuestions+ aninhados

  def as_json(options: {})
    super(include: [
          :survey_questions => {
            include: [
              multiple_choice: {include: :options},
              likert_scale: {include: :likert_questions}
            ]
          }
        ])
  end
end
