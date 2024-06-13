class Turma < ApplicationRecord
    belongs_to :materia
    has_and_belongs_to_many :users
    has_many :formularios
end
