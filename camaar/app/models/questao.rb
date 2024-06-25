class Questao < ApplicationRecord
  validates :texto, presence: true

  belongs_to :formulario
  belongs_to :template
  has_one :resposta
end
