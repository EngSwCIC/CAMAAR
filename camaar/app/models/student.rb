class Student < ApplicationRecord
  has_many :enrollment
  has_many :subject_class, :through => :enrollment
end
