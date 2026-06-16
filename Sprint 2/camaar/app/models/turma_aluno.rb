class TurmaAluno < ApplicationRecord
  belongs_to :turma, foreign_key: :turma_id
  belongs_to :user, foreign_key: :aluno_id
end