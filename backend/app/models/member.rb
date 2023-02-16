class Member < ApplicationRecord
    has_many :enrollments
    has_many :cclasses, through: :enrollments
    has_and_belongs_to_many :answered_surveys, join_table: :answered_surveys, class_name: 'Survey'
    has_one :user
    belongs_to :role
end
