class SurveyAnswer < ApplicationRecord
  belongs_to :survey
  belongs_to :member
  has_many :answers, dependent: :destroy
end
