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
