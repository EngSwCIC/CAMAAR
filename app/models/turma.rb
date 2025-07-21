class Turma < ApplicationRecord
  # belongs_to :materia, foreign_key: :id_materia, optional: true
  belongs_to :materia, foreign_key: 'id_materia', primary_key: 'id', optional: true
  
  has_many :participantes, foreign_key: 'id_turma', dependent: :destroy
  has_many :pessoas, through: :participantes
  has_many :formularios, dependent: :destroy
end
