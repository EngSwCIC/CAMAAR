class Tipo < ApplicationRecord
  validates :nome, presence: true
  validates :numeroDeAlternativas, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  validates :discursiva?, presence: true
end
