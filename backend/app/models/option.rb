class Option < ApplicationRecord
  belongs_to :survey_question

  validates :option, presence: true
end
