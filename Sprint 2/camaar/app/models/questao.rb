class Questao < ApplicationRecord
  belongs_to :template
  has_many :respostas, dependent: :destroy
end
