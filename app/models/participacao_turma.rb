# frozen_string_literal: true

class ParticipacaoTurma < ApplicationRecord
  enum :tipo_participacao, {
    docente: 0,
    discente: 1
  }

  belongs_to :usuario,
    class_name: "Usuario",
    inverse_of: :participacoes_turma

  belongs_to :turma,
    class_name: "Turma",
    inverse_of: :participacoes_turma

  has_many :avaliacoes,
    class_name: "Avaliacao",
    dependent: :restrict_with_error,
    inverse_of: :participacao_turma

  validates :tipo_participacao, presence: true
  validates :usuario, presence: true
  validates :turma, presence: true

  validates :usuario_id,
    uniqueness: {
      scope: %i[turma_id tipo_participacao],
      message: "já possui essa participação nesta turma"
    }

  validate :usuario_deve_ter_perfil_compativel

  scope :docentes, -> { where(tipo_participacao: :docente) }
  scope :discentes, -> { where(tipo_participacao: :discente) }

  def corresponde_ao_publico?(publico_alvo)
    return docente? if publico_alvo.to_s == "docentes"
    return discente? if publico_alvo.to_s == "discentes"

    false
  end

  private

  def usuario_deve_ter_perfil_compativel
    return if usuario.blank?

    validar_perfil_docente if docente?
    validar_perfil_discente if discente?
  end

  def validar_perfil_docente
    return if usuario.docente?

    errors.add(:usuario, "deve possuir perfil docente")
  end

  def validar_perfil_discente
    return if usuario.discente?

    errors.add(:usuario, "deve possuir perfil discente")
  end
end
