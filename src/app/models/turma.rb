class Turma < ApplicationRecord
    belongs_to :professor, class_name: 'User', foreign_key: 'professor_id'
    belongs_to :materia
    has_many :formularios

    has_many :users_turmas
    has_many :users, through: :users_turmas
    
end
