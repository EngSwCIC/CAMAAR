class Turma < ApplicationRecord
  belongs_to :materia
  belongs_to :professor

  has_many :matriculas
  has_many :estudantes,through: :matriculas
  has_many :formularios
end
