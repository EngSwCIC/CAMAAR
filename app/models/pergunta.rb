class Pergunta < ApplicationRecord
  belongs_to :formulario
  has_many :respostas, dependent: :destroy

  validates :enunciado, presence: true
  validates :tipo_pergunta, presence: true, inclusion: { in: %w[texto multipla_escolha escala] }
end
