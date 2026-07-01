# Representa uma turma de uma disciplina ministrada por um docente.
# Associa discentes e formulários de avaliação.
class Turma < ApplicationRecord
  belongs_to :disciplina, foreign_key: 'disciplina_id', primary_key: 'codigo'
  belongs_to :docente
  has_many :turma_discentes, dependent: :destroy
  has_many :discentes, through: :turma_discentes
  has_many :formularios, dependent: :destroy
end
