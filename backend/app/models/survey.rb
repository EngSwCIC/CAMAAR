class Survey < ApplicationRecord
    has_many :survey_questions, dependent: :destroy
    has_many :survey_answers, dependent: :destroy
end
