class Enrollment < ApplicationRecord
    belongs_to :cclass
    belongs_to :member
    has_many :question_answers
end
