class Student < ApplicationRecord
  validates :email, uniqueness: true
  validates :registration, uniqueness: true
  has_many :enrollment
  has_many :subject_class, :through => :enrollment
  belongs_to :user, optional: true
end
