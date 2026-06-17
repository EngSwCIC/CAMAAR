class TurmaDiscente < ApplicationRecord
  belongs_to :discente
  belongs_to :turma
end