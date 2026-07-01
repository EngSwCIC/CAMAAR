# app/models/turma.rb
class Turma < ApplicationRecord
  belongs_to :departamento
  belongs_to :disciplina, optional: true
  belongs_to :docente, optional: true

  validates :codigo, presence: true
  validates :nome, presence: true
end
