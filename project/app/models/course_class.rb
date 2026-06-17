class CourseClass < ApplicationRecord
  belongs_to :department
  has_many :class_memberships, dependent: :destroy
  has_many :users, through: :class_memberships

  validates :code, :class_code, :semester, presence: true
  validates :code, uniqueness: { scope: [ :class_code, :semester ] }
end
