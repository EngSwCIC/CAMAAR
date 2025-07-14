# frozen_string_literal: true

class Matricula < ApplicationRecord
  belongs_to :user
  belongs_to :turma
  has_one :disciplina, through: :turma
  has_one :aluno, -> { where(role: 'aluno') }, class_name: 'User', foreign_key: 'user_id'
  
  validates :situacao, inclusion: { in: %w[matriculado aprovado reprovado] }
  validates :user_id, uniqueness: { scope: :turma_id, message: "já está matriculado nesta turma" }
  
  before_validation :set_default_situacao
  
  private
  
  def set_default_situacao
    self.situacao ||= 'matriculado'
  end
end
