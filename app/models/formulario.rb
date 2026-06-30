##
# Define a model para representar um formulário associado a um template e a uma turma, incluindo validações e métodos auxiliares para gerenciar respostas e participantes.
# == Schema:
#  * id: integer, primary key
#  * template_id: integer, foreign key para o template
#  * turma_id: integer, foreign key para a turma
#  * titulo: string, título do formulário
class Formulario < ApplicationRecord
  belongs_to :template
  belongs_to :turma
  has_many :respostas, dependent: :destroy
  has_many :questions, through: :template

  validates :titulo, presence: true

  # Define os discentes que devem responder
  def participantes
    turma.discentes
  end

  def total_participantes
    participantes.count
  end

  # Quantos discentes distintos já enviaram respostas
  def total_respondentes
    respostas.select(:user_id).distinct.count
  end

  # Verifica se um usuário específico já respondeu ao formulário
  def respondido_por?(user)
    return false if user.nil?
    respostas.exists?(user_id: user.id)
  end

  # Retorna respostas de uma questão específica
  def respostas_da(question)
    respostas.where(question_id: question.id)
  end
end
