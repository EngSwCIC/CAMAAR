class Option < ApplicationRecord
    belongs_to :avaliation
    has_many :answers
end
