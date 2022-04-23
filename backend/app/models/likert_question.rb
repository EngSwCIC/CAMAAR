class LikertQuestion < ApplicationRecord
    belongs_to :likert_scale

    validates :question, presence: true
end
