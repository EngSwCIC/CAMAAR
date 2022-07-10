##
# Essa classe representa o model ActiveRecord que armazena respostas às perguntas de
# Survey para cada par de Member e Cclass

class QuestionAnswer < ApplicationRecord
  belongs_to :survey_question
  has_many :likert_scale_answers
  accepts_nested_attributes_for :likert_scale_answers
end
