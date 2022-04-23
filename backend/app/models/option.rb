class Option < ApplicationRecord
    belongs_to :multiple_choice

    validates :option, presence: true
end
