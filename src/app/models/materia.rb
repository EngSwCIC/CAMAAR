class Materia < ApplicationRecord
    belongs_to :departamento
    has_many_and_belongs_to_many :turmas 
end
