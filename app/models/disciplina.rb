# frozen_string_literal: true

class Disciplina < ApplicationRecord
  belongs_to :curso
  has_many :turmas, dependent: :destroy
  has_many :matriculas, through: :turmas
  has_many :alunos, through: :matriculas, source: :user
  has_many :professores, through: :turmas, source: :professor

  validates :nome, presence: true, length: { minimum: 2 }

  # Validações para campos importados
  validates :codigo, length: { maximum: 20 }, allow_blank: true
  validates :codigo_turma, length: { maximum: 10 }, allow_blank: true
  validates :semestre, length: { maximum: 10 }, allow_blank: true
  validates :horario, length: { maximum: 50 }, allow_blank: true

  # Scope para buscar disciplinas únicas por código
  scope :by_codigo, ->(codigo) { where(codigo: codigo) }
end
