class SurveyAnswer < ApplicationRecord
  belongs_to :survey
  belongs_to :enrollment
  has_many :answers

  validate :memberIsDocente

  def memberIsDocente
    if(self.enrollment.member.occupation != "docente")
      errors.add(:enrollment, "Membro associado não é um doscente")
    end
  end
end
