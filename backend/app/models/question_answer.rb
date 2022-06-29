##
# Essa classe representa o model ActiveRecord que armazena respostas às perguntas de
# Survey para cada par de Member e Cclass

class QuestionAnswer < ApplicationRecord
  belongs_to :enrollment
  belongs_to :survey_question
end
