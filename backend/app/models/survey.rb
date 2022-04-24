class Survey < ApplicationRecord
    validates :semester, format: {with: /\d{4}.\d/}
    has_many :survey_questions, dependent: :destroy
    has_many :survey_answers, dependent: :destroy
end
