class Turma < ApplicationRecord
    has_and_belongs_to_many :users
    has_and_belongs_to_many :materias
    has_many :formularios_respostas
end
