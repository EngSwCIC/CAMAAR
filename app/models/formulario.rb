class Formulario < ApplicationRecord
  belongs_to :template
  belongs_to :turma
  has_many :respostas, dependent: :destroy
  has_many :questions, through: :template

  validates :titulo, presence: true

  # Discentes que devem responder
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

  def respondido_por?(user)
    return false if user.nil?
    respostas.exists?(user_id: user.id)
  end

  # Respostas de uma questão específica
  def respostas_da(question)
    respostas.where(question_id: question.id)
  end
end
