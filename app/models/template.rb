class Template < ApplicationRecord
  has_many :form
  has_many :questions, as: :formlike
end
