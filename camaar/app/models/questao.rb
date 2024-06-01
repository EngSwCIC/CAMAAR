class Questao < ApplicationRecord
  belongs_to :formulario
  has_one :template

  validates :pergunta, presence: true
  validates :alternativas, presence: true, if: -> { !template.discursiva? }
  validates :pontos, numericality: { greater_than_or_equal_to: 0 }
  validates :fatorDeCorrecao, numericality: { greater_than_or_equal_to: 0 }
  validates :alternativaCorreta, numericality: { only_integer: true}

  validate :alternativa_correta_check, unless: -> { template.discursiva? }

  private

  def alternativa_correta_check
    if !alternativas.key?(alternativaCorreta)
      errors.add(:alternativaCorreta, "alternativa correta não está em alternativas")
    end
  end
end
