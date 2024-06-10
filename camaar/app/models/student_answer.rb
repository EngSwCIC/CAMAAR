class StudentAnswer < ApplicationRecord
  belongs_to :form_question
  belongs_to :student
end
