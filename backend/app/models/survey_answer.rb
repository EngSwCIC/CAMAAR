class SurveyAnswer < ApplicationRecord
  belongs_to :survey
  belongs_to :member
  belongs_to :cclass
  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers

  validate :is_grad_student

  def as_json(options: {})
    super(include: [:answers => {include: :likert_answers}])
  end

  private

  def is_grad_student
    errors.add(:member, 'membro deve ser dicente') unless member&.occupation == 'dicente'
  end
end
