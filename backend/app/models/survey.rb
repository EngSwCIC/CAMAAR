class Survey < ApplicationRecord
    has_many :survey_question
    has_many :survey_answer
end
