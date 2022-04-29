##
# Essa classe representa o model ActiveRecord que armazena sub-perguntas de uma
# pergunta do tipo LikertScale de um questionário

class LikertQuestion < ApplicationRecord
    belongs_to :likert_scale
    has_many :likert_answers

    validates :question, presence: true
end
