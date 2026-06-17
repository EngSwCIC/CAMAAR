class Departamento < ApplicationRecord
  has_many :cursos, dependent: :restrict_with_error
  has_many :disciplinas, dependent: :restrict_with_error
  has_many :administradores
  validates :codigo, presence: true, uniqueness: true
  validates :nome, presence: true
end
