# frozen_string_literal: true

class PerfilDocente < ApplicationRecord
  self.primary_key = :id

  belongs_to :usuario,
    class_name: "Usuario",
    foreign_key: :id,
    inverse_of: :perfil_docente

  belongs_to :departamento,
    class_name: "Departamento",
    foreign_key: :departamento_id,
    inverse_of: :perfil_docentes

  has_many :participacoes_turma, through: :usuario, source: :participacoes_turma

  has_many :turmas, through: :participacoes_turma

  validates :id, presence: true, uniqueness: true

  validates :departamento, presence: true

  def nome
    usuario.nome
  end

  def email
    usuario.email
  end
end
