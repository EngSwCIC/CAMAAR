##
# Essa classe representa o model ActiveRecord que armazena pergunta do Survey 
# que será utilizada para avaliar cada Cclass

class SurveyQuestion < ApplicationRecord
  belongs_to :survey
  belongs_to :question_type
  has_many :question_answers
  has_many :question_options
end
