class LikertAnswer < ApplicationRecord
  belongs_to :answer
  belongs_to :likert_question

  validate :required_questions_answered

  private 

  def required_questions_answered
    errors.add(:content, 'is missing') if not answer.survey_question.optional and content.nil?
  end
end
