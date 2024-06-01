class Template < ApplicationRecord
  belongs_to :administrador

  validates :nome, presence: true
  validates :numeroDeAlternativas, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  validates :discursiva?, presence: true
  validates :fatorDeCorrecao?, presence: true

  validate :discursiva_alternatives_check

  private

  def discursiva_alternatives_check
    if discursiva? && numeroDeAlternativas != 0
      errors.add(:numeroDeAlternativas, "Precisa ser 0 para questões discursivas")
    elsif !discursiva? && (numeroDeAlternativas < 2 || numeroDeAlternativas > 5)
      errors.add(:numeroDeAlternativas, "Uma questão não pode ter apenas 1 alternativa")
    end
  end
end
