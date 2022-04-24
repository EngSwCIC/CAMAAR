class Answer < ApplicationRecord
  belongs_to :survey_answer
  belongs_to :survey_question
end
