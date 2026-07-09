# app/models/turma.rb
class Turma < ApplicationRecord
  belongs_to :departamento

  validates :codigo, presence: true
  validates :nome, presence: true
end
