class LikertScale < ApplicationRecord
  belongs_to :survey_question
  has_many :likert_questions, dependent: :destroy
  accepts_nested_attributes_for :likert_questions

  validate :question_type_is_valid

  private

  def question_type_is_valid
    unless !survey_question.nil? and survey_question.question_type == 'likert_scale'
      errors.add(:survey_question, 'is of invalid type') 
    end
  end
end
