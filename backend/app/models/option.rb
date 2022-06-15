##
# Essa classe representa o model ActiveRecord que armazena possíveis respostas
# para um SurveyQuestion do tipo _"multiple_choice"_

class Option < ApplicationRecord
    belongs_to :multiple_choice

    validates :option, presence: true
end
