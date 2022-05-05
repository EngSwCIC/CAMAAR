class SurveyQuestion < ApplicationRecord
  belongs_to :survey
  has_one :multiple_choice
  has_one :likert_scale
  has_many :answers
  accepts_nested_attributes_for :multiple_choice, :likert_scale

  validates :question, :question_type, presence: true
  validate :question_type_exists

  def possibilities
    ['likert_scale', 'multiple_choice', 'discursive']
  end

  private

  def question_type_exists
    errors.add(:question_type, 'is invalid') unless self.possibilities.include? question_type
  end
end
