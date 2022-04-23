class SurveyAnswer < ApplicationRecord
  belongs_to :survey
  belongs_to :member
  belongs_to :subject
  has_many :answers, dependent: :destroy
end
