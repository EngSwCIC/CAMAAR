class Role < ApplicationRecord
  has_many :member
  has_many :survey
end
