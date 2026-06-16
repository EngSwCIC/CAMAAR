class Question < ApplicationRecord
  TIPOS = %w[discursiva multipla_escolha].freeze

  belongs_to :template, inverse_of: :questions

  validates :enunciado, presence: true
  validates :tipo, inclusion: { in: TIPOS }
  # Questão de múltipla escolha precisa de opções
  validates :opcoes, presence: true, if: :multipla_escolha?

  def multipla_escolha?
    tipo == "multipla_escolha"
  end

  # Opções vêm de um textarea (uma por linha); devolve lista limpa
  def opcoes_lista
    opcoes.to_s.split("\n").map(&:strip).reject(&:blank?)
  end
end
