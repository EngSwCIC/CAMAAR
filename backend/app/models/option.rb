class Option < ApplicationRecord
  belongs_to :survey_question
  has_many :selected_options

  validates :option, presence: true
  validate :questionIsOption

  def questionIsOption
    if(self.survey_question.question_type != "Caixa de Seleção")
      errors.add(:survey_question, "Questão não é do tipo Caixa de Seleção")
    end
  end
end
