# Representa uma disciplina ofertada por um +Departamento+.
#
# Pode ter múltiplas +Turma+s associadas (uma por semestre/oferta). Identificada
# de forma única pelo atributo +codigo+, que corresponde ao código do SIGAA.
class Disciplina < ApplicationRecord
  belongs_to :departamento
  has_many :turmas, dependent: :destroy
  validates :codigo, presence: true, uniqueness: true
  validates :nome, presence: true
end
