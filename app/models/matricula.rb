class Matricula < ApplicationRecord
  self.table_name = "matriculas"

  belongs_to :turma
  belongs_to :usuario

  validates :papel_na_turma, presence: true
  validates :usuario_id, uniqueness: { scope: :turma_id }
end
