class Materia < ApplicationRecord
    belongs_to :departamento
    has_and_belongs_to_many :turmas 
end
