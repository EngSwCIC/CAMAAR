# Tabela de junção entre +Turma+ e +Discente+.
# Registra a matrícula de um discente em uma turma.
class TurmaDiscente < ApplicationRecord
  belongs_to :discente
  belongs_to :turma
end
