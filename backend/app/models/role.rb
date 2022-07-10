class Role < ApplicationRecord
  has_many :members
  has_many :surveys
end
