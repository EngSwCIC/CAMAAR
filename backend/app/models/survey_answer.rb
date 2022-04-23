class SurveyAnswer < ApplicationRecord
  belongs_to :survey
  belongs_to :enrollment
end
