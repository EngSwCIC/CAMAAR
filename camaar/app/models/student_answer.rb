class StudentAnswer < ApplicationRecord
  belongs_to :form
  belongs_to :student
end
