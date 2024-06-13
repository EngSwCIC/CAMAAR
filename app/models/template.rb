class Template < ApplicationRecord
  belongs_to :semester
  has_many :questions
end
