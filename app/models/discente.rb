# Representa um aluno vinculado a uma +Pessoa+.
# Possui matrículas em turmas e respostas a formulários.
class Discente < ApplicationRecord
  belongs_to :pessoa, foreign_key: 'pessoa_id', primary_key: 'usuario'
  has_many :turma_discentes, dependent: :destroy
  has_many :turmas, through: :turma_discentes
  has_many :respostas, dependent: :destroy
end
