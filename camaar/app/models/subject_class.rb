class SubjectClass < ApplicationRecord
  belongs_to :department
  has_one :teacher
end
