class Answer < ApplicationRecord
  belongs_to :survey_answer
  belongs_to :survey_question
  has_many :likert_answers, dependent: :destroy
  accepts_nested_attributes_for :likert_answers

  validates :content, presence: true, if: -> { question_type != 'likert_scale' }
end
