class Department < ApplicationRecord
  validates :initials, uniqueness: true
end
