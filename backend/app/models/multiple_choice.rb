##
# Essa classe representa o model ActiveRecord que serve de tabela intermediário entre
# SurveyQuesion e Options

class MultipleChoice < ApplicationRecord
  belongs_to :survey_question
  has_many :options, dependent: :destroy
  accepts_nested_attributes_for :options

  validate :question_type_is_valid

  private

  ##
  # Valida se +question_type+ é do tipo _"multiple_choice"_
  #
  # É chamada durante a execução do método +MultipleChoice:save+.
  #
  # Adiciona um erro ao model caso +question_type != 'multiple_choice'+ 

  def question_type_is_valid
    unless !survey_question.nil? and survey_question.question_type == 'multiple_choice'
      errors.add(:survey_question, 'is of invalid type') 
    end
  end
end
