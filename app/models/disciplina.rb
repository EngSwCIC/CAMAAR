class Disciplina < ApplicationRecord
  self.table_name = "disciplinas"

  has_many :turmas, dependent: :destroy

  validates :codigo, presence: true, uniqueness: true
  validates :nome, presence: true

  def departamento
    turmas.first&.departamento || Departamento.first
  end
end
