class Participante < ApplicationRecord
  belongs_to :pessoa, foreign_key: 'email'
  belongs_to :turma, foreign_key: 'id_turma'
end
