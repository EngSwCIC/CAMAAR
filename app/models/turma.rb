class Turma < ApplicationRecord
  belongs_to :disciplina
  belongs_to :professor
end
