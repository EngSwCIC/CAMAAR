class Enrollment < ApplicationRecord
  belongs_to :student
  belongs_to :subject_classes
end
