class Member < ApplicationRecord
    has_many :enrollments
    has_many :cclasses, through: :enrollments
    has_one :user
end
