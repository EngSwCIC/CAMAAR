class Form < ApplicationRecord
  belongs_to :template, optional: true
  has_many :questions, as: :formlike
  belongs_to :semester
end
