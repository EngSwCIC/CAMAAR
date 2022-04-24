class Subject < ApplicationRecord
  validates :code, presence: true, uniqueness: true 
  validates :name, presence: true, uniqueness: true 
  has_many :cclasses
end
