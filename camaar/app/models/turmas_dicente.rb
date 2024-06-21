class TurmasDicente < ApplicationRecord
  belongs_to :turma
  belongs_to :dicente
end
