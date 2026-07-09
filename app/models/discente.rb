# app/models/discente.rb
class Discente < ApplicationRecord
  belongs_to :usuario

  has_many :matriculas,        dependent: :destroy
  has_many :turmas,            through: :matriculas
  has_many :envio_formularios, dependent: :destroy

  validates :curso,     presence: true
  validates :matricula, presence: true, uniqueness: true

  delegate :nome, :email, to: :usuario

  # Retorna formulários de turmas do discente que ele ainda não respondeu
  def formularios_disponiveis
    Formulario
      .where(turma_id: turmas.pluck(:id))
      .where.not(id: envio_formularios.pluck(:formulario_id))
  end

  def ja_respondeu?(formulario)
    envio_formularios.exists?(formulario: formulario)
  end
end
