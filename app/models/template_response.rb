class TemplateResponse < ApplicationRecord
  belongs_to :user
  belongs_to :template
  has_many :question_answers, dependent: :destroy

  validates :user_id, uniqueness: { scope: :template_id }

  def complete?
    submitted_at.present?
  end

  def answer_for_question(question)
    question_answers.find_by(template_question: question)
  end
end
