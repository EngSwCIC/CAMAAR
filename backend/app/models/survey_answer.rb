class SurveyAnswer < ApplicationRecord
  belongs_to :survey
  belongs_to :enrollment
  has_many :answers
end
