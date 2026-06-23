class Department < ApplicationRecord
  has_many :course_classes, dependent: :restrict_with_exception
  has_many :users, dependent: :nullify

  validates :name, :code, presence: true
  validates :code, uniqueness: true
end
