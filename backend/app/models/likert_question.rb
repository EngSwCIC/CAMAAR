class LikertQuestion < ApplicationRecord
    belongs_to :likert_scale
    has_many :likert_answers

    validates :question, presence: true
end
