class Cclass < ApplicationRecord
    belongs_to: subject
    has_many :enrollments
    has_many :members, throught: :enrollments
end
