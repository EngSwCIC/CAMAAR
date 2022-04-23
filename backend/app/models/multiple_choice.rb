class MultipleChoice < ApplicationRecord
  belongs_to :survey_question
  has_many :options, dependent: :destroy
  accepts_nested_attributes_for :options
end
