class Template < ApplicationRecord
  has_one :semester
  has_many :questions
end
