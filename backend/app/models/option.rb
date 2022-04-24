class Option < ApplicationRecord
  belongs_to :survey_question
  has_many :selected_options

  validates :option, presence: true
  validates :option, uniqueness: { scope: :survey_question_id }
end
