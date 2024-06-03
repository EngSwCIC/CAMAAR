class Teacher < ApplicationRecord
  belongs_to :department
  belongs_to :user, optional: true
end
