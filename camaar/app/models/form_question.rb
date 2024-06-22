class FormQuestion < ApplicationRecord
  has_one :form
  has_many :student_answer, dependent: :delete_all
  has_many :teacher_answer, dependent: :delete_all
end
