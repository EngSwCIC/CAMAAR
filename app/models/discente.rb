# app/models/discente.rb
class Discente < ApplicationRecord
  belongs_to :usuario

  has_many :matriculas,        dependent: :destroy
  has_many :turmas,            through: :matriculas
  has_many :envio_formularios, dependent: :destroy

  validates :curso,     presence: true
  validates :matricula, presence: true, uniqueness: true

  delegate :nome, :email, to: :usuario

  # Retorna os formulários vinculados às turmas do discente que ainda não foram respondidos.
  #
  # @return [ActiveRecord::Relation<Formulario>] lista de formulários disponíveis para resposta
  def formularios_disponiveis
    Formulario
      .where(turma_id: turmas.pluck(:id))
      .where.not(id: envio_formularios.pluck(:formulario_id))
  end

  # Verifica se o discente já respondeu determinado formulário.
  #
  # @param formulario [Formulario] formulário que será consultado
  # @return [Boolean] true quando já existe um envio para o formulário informado
  def ja_respondeu?(formulario)
    envio_formularios.exists?(formulario: formulario)
  end
end
