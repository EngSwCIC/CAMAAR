# frozen_string_literal: true

class Materia < ApplicationRecord
  belongs_to :departamento,
    class_name: "Departamento",
    inverse_of: :materias

  has_many :turmas,
    class_name: "Turma",
    dependent: :restrict_with_error,
    inverse_of: :materia

  validates :codigo,
    presence: true,
    uniqueness: { case_sensitive: false }

  validates :nome, presence: true
  validates :departamento, presence: true

  before_validation :normalizar_codigo
  before_validation :normalizar_nome

  scope :do_departamento, ->(departamento) {
    where(departamento_id: departamento.id)
  }

  private

  def normalizar_codigo
    self.codigo = codigo.to_s.strip.upcase
  end

  def normalizar_nome
    self.nome = nome.to_s.strip
  end
end
