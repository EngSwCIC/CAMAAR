class SurveyQuestion < ApplicationRecord
  belongs_to :survey
  has_one :multiple_choice
  has_one :likert_scale
end
