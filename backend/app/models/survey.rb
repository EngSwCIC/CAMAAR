class Survey < ApplicationRecord
    has_many :survey_question, dependent: :destroy
    has_many :survey_answer, dependent: :destroy

    validates :semester, format: {with: /\d{4}.\d/}
end
