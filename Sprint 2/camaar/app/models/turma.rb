class Turma < ApplicationRecord
  belongs_to :disciplina

  has_many :turma_alunos, dependent: :destroy
  has_many :alunos, through: :turma_alunos, source: :user

  validates :codigo, :semestre, :horario, presence: true
  validates :disciplina, presence: true
end