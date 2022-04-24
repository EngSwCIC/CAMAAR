class Option < ApplicationRecord
  belongs_to :survey_question

  validates :option, presence: true
  validates :option, uniqueness: { scope: :survey_question_id }
end
