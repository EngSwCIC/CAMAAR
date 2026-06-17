class Turma < ApplicationRecord
  belongs_to :disciplina
  has_many :discentes, dependent: :destroy
  has_many :docentes, dependent: :destroy
  has_many :formularios, dependent: :destroy
end
