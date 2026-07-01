# Representa uma oferta de disciplina em um determinado semestre.
#
# Agrupa +Discente+s e +Docente+s que cursam/ministram uma +Disciplina+ em um
# semestre específico. Cada turma pode ter múltiplos +Formulario+s de avaliação
# associados. O número da turma é único dentro do escopo de semestre e disciplina.
class Turma < ApplicationRecord
  belongs_to :disciplina
  has_many :formularios, dependent: :destroy
  has_and_belongs_to_many :discentes, join_table: "discentes_turmas"
  has_and_belongs_to_many :docentes, join_table: "docentes_turmas"

  validates :numero_da_turma, presence: true, uniqueness: {
    scope: [ :semestre, :disciplina_id ]
  }
  validates :semestre, presence: true
end
