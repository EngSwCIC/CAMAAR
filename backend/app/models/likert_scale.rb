class LikertScale < ApplicationRecord
  belongs_to :survey_question
  has_many :likert_questions, dependent: :destroy
end
