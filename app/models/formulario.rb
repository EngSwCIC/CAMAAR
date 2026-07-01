# Representa um formulário de avaliação vinculado a uma turma.
# Pode estar com status +:aberto+ (aceitando respostas) ou +:fechado+.
# Opcionalmente derivado de um +Template+.
class Formulario < ApplicationRecord
  belongs_to :turma
  belongs_to :template, optional: true
  has_many :questoes, dependent: :destroy
  enum status: { aberto: 0, fechado: 1 }
end
