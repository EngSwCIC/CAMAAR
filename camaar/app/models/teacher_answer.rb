class TeacherAnswer < ApplicationRecord
  belongs_to :form_question
  belongs_to :teacher
end
