class Answer < ApplicationRecord
  belongs_to :survey_answer
  belongs_to :survey_question
  has_many :likert_answers, dependent: :destroy
  accepts_nested_attributes_for :likert_answers

  validate :required_questions_answered

  private 

  def required_questions_answered
    if !survey_question.nil? and survey_question.question_type != 'likert_scale'
      if !survey_question.optional and content.nil?
        errors.add(:content, 'is missing') 
      end
    end
  end
end
