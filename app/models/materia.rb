class Materia < ApplicationRecord
  self.table_name = "materia"

  belongs_to :departamento
  has_many :turmas
end
