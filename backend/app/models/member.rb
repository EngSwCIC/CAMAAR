class Member < ApplicationRecord
    has_many :enrollments
    has_many :cclasses throught: :enrollments
    has_one :user
end
