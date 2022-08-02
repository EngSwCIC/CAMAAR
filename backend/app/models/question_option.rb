##
# Essa classe representa o model ActiveRecord que armazena possíveis respostas
# para um SurveyQuestion do tipo _"multiple_choice"_

class QuestionOption < ApplicationRecord
    belongs_to :survey_question
end
