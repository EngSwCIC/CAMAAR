class TeacherAnswer < ApplicationRecord
  belongs_to :form
  belongs_to :teacher
end
