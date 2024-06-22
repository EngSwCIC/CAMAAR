class Enrollment < ApplicationRecord
  belongs_to :student, optional: true
  belongs_to :subject_class, optional: true
end
