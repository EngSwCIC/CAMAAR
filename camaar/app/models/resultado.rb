class Resultado < ApplicationRecord
  belongs_to :dicente
  belongs_to :formulario

  validates :nota, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
