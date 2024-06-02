class SubjectClass < ApplicationRecord
  belongs_to :department
  has_one :teacher

  has_many :enrollment
  has_many :student, :through => :enrollment
end
