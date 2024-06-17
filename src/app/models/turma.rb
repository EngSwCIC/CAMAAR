class Turma < ApplicationRecord
    belongs_to :professor, class_name: 'User', foreign_key: 'professor_id'
    belongs_to :materia
    has_many :formularios, foreign_key: 'id_turma'
end
