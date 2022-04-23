class Answer < ApplicationRecord
  belongs_to :survey_answer

  validates :content, presence: true
end
