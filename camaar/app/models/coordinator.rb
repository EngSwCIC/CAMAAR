class Coordinator < ApplicationRecord
  belongs_to :department
  belongs_to :admin
  validates :email, uniqueness: true
end
