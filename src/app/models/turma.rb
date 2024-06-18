class Turma < ApplicationRecord
    belongs_to :materia
    has_many :formularios

    has_many :users_turmas
    has_many :users, through: :users_turmas
    
end