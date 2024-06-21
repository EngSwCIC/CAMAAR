class Questao < ApplicationRecord
  belongs_to :template
  has_one :tipo
  has_many :alternativas, dependent: :destroy,  class_name: "Alternativa"
  accepts_nested_attributes_for :alternativas, reject_if: :all_blank, allow_destroy: true

  validates :pergunta, presence: true
end
