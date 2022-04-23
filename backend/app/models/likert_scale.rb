class LikertScale < ApplicationRecord
  belongs_to :survey_question
  has_many :likert_questions, dependent: :destroy
  accepts_nested_attributes_for :likert_questions
end
