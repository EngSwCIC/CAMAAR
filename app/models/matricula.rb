# frozen_string_literal: true

# == Schema Information
#
# Table name: matriculas
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  turma_id   :integer          not null
#  situacao   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Matricula < ApplicationRecord
  belongs_to :user
  belongs_to :turma
  has_one :disciplina, through: :turma

  validates :situacao, inclusion: { in: %w[matriculado aprovado reprovado] }
  # NOTE: This uniqueness validation might need a database index for better performance
  validates :user_id, uniqueness: { scope: :turma_id, message: 'já está matriculado nesta turma' }

  before_validation :set_default_situacao

  # Helper method to get the student (aluno) associated with this matricula
  #
  # ==== Returns
  #
  # * +User+ - O usuário associado se ele for um aluno.
  # * +nil+ - Se o usuário não for um aluno.
  #
  def aluno
    user if user&.aluno?
  end

  private

  def set_default_situacao
    self.situacao ||= 'matriculado'
  end
end
