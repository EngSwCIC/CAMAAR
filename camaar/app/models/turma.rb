class Turma < ApplicationRecord
  validates :codigo, presence: true, format: { with: /\A[A-Z]{2}\z/ }
  validates :semestre, presence: true, format: { with: /\A[0-9]{4}\.[1-2]\z/ }
  validates :horario, presence: true, format: { with: /\A[0-9]{2}[T|N|M][0-9]{2}\z/ }

  belongs_to :materia
  has_one :formulario
  has_many :matriculas
  has_many :users, through: :matriculas
end
