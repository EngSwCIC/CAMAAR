class Answer < ApplicationRecord
  belongs_to :survey_answer
  belongs_to :survey_question

  validate :answerIsRequired

  def answerIsRequired
    if(self.survey_question.optional == false && content == nil)
      errors.add(:content, "Resposta é obrigatória")
    end
  end
end
