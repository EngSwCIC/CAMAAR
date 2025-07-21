class Materia < ApplicationRecord
  self.primary_key = 'id'
  has_many :turmas, foreign_key: 'id_materia', inverse_of: :materia
end
