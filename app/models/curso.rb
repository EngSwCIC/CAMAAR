class Curso < ApplicationRecord
  self.table_name = "cursos"
  validates :nome, presence: true, uniqueness: true
end
