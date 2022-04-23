class Survey < ApplicationRecord
  has_many :survey_answers
  has_many :survey_questions, dependent: :destroy
  accepts_nested_attributes_for :survey_questions

  validates :name, :description, :expiration_date, :semester, presence: true
end
