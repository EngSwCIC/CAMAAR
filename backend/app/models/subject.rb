class Subject < ApplicationRecord
  validates :code, presence: true, uniqueness: true 
  validates :name, presence: true, uniqueness: true 
  has_many :cclasses
  has_many :survey_answers
end
