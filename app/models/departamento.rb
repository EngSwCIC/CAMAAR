class Departamento < ApplicationRecord
  has_many :materias
  has_many :admins
end
