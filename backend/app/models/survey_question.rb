class SurveyQuestion < ApplicationRecord
  belongs_to :survey
  has_one :multiple_choice
  has_one :likert_scale
  accepts_nested_attributes_for :multiple_choice, :likert_scale

  validates :question, :question_type, presence: true
end
