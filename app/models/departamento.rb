class Departamento < ApplicationRecord
  validates :nome, uniqueness: true, presence: true
  has_many :professor
  has_many :materias

  end
