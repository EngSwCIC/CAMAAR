class Cclass < ApplicationRecord
    belongs_to :subject
    has_many :enrollments
    has_many :members, through: :enrollments
    has_many :survey_answers
    has_many :member_cclasses
end
