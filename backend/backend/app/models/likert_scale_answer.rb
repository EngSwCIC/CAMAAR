class LikertScaleAnswer < ApplicationRecord
    belongs_to :likert_scale_question
    belongs_to :question_answer
end
