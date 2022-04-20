class Survey < ApplicationRecord
  has_many :survey_answers
  has_many :survey_questions, dependent: :destroy
end
