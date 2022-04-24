class LikertAnswer < ApplicationRecord
    belongs_to :answer
    belongs_to :likert_question
end
