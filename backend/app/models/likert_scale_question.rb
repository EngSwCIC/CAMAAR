class LikertScaleQuestion < ApplicationRecord
  belongs_to :survey_question
  has_many :likert_scale_answers
end
