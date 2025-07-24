class QuestionAnswer < ApplicationRecord
  belongs_to :template_response
  belongs_to :template_question

  validates :template_response_id, uniqueness: { scope: :template_question_id }
end
