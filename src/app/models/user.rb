class User < ApplicationRecord
  has_secure_password

  has_many :class_professors, foreign_key: :professor_id
  has_many :teaching_classes, through: :class_professors, source: :class_group

  has_many :class_students, foreign_key: :student_id
  has_many :attending_classes, through: :class_students, source: :class_group

  has_many :templates, foreign_key: :creator_id
  has_many :forms_published, class_name: "Form", foreign_key: :publisher_id

  has_many :answered_forms

  validates :email, presence: true, uniqueness: true
end
