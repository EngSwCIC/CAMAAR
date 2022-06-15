##
# Essa classe representa o model ActiveRecord que armazena pergunta do Survey 
# que será utilizada para avaliar cada Cclass

class SurveyQuestion < ApplicationRecord
  belongs_to :survey
  has_one :multiple_choice
  has_one :likert_scale
  has_many :answers
  accepts_nested_attributes_for :multiple_choice, :likert_scale

  validates :question, :question_type, presence: true
  validate :question_type_exists

  ##
  # Método que retorna os possíveis valores de +question_type+

  def possibilities
    ['likert_scale', 'multiple_choice', 'discursive']
  end

  private

  ##
  # Valida se +question_type+ está entre as possibilidades retornadas pelo método +possibilities+
  #
  # É chamada durante a execução do método +SurveyQuestion::save+.
  #
  # Adiciona um erro ao model a não ser que +possibilities.include? question_type+

  def question_type_exists
    errors.add(:question_type, 'is invalid') unless self.possibilities.include? question_type
  end
end
