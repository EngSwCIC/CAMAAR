class Questao < ApplicationRecord
  belongs_to :template
  has_one :tipo

  validates :pergunta, presence: true
  validates :alternativas, presence: true, if: -> { !tipo.discursiva? }
  validates :pontos, numericality: { greater_than_or_equal_to: 0 }
  validates :fatorDeCorrecao, numericality: { greater_than_or_equal_to: 0 }, presence: true, if: -> { tipo.fatorDeCorrecao? }
  validates :alternativaCorreta, presence: true,  unless: -> { template.discursiva? }
end
