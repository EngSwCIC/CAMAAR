class Departamento < ApplicationRecord
    has_many_and_belongs_to_many :users
    has_many :materias
end
