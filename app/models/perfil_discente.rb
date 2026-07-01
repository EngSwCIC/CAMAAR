# frozen_string_literal: true

class PerfilDiscente < ApplicationRecord
  self.primary_key = :id

  belongs_to :usuario,
    class_name: "Usuario",
    foreign_key: :id,
    inverse_of: :perfil_discente

  has_many :participacoes_turma, through: :usuario, source: :participacoes_turma

  has_many :turmas, through: :participacoes_turma

  validates :id, presence: true, uniqueness: true

  def nome
    usuario.nome
  end

  def email
    usuario.email
  end
end
