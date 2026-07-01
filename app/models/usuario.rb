# frozen_string_literal: true

class Usuario < ApplicationRecord
  has_secure_password :senha, validations: false

  enum :status, {
    pendente: 0,
    ativo: 1
  }

  has_one :perfil_adm,
    class_name: "PerfilAdm",
    foreign_key: :id,
    inverse_of: :usuario,
    dependent: :destroy

  has_one :perfil_docente,
    class_name: "PerfilDocente",
    foreign_key: :id,
    inverse_of: :usuario,
    dependent: :destroy

  has_one :perfil_discente,
    class_name: "PerfilDiscente",
    foreign_key: :id,
    inverse_of: :usuario,
    dependent: :destroy

  has_many :participacoes_turma,
    class_name: "ParticipacaoTurma",
    foreign_key: :usuario_id,
    inverse_of: :usuario,
    dependent: :restrict_with_error

  has_many :turmas, through: :participacoes_turma

  has_many :templates_criados, through: :perfil_adm, source: :templates

  has_many :tokens,
    class_name: "Token",
    inverse_of: :usuario,
    dependent: :destroy

  before_validation :normalizar_email
  before_validation :normalizar_matricula

  validates :nome, presence: true, length: { maximum: 255 }

  validates :matricula,
    presence: true,
    uniqueness: true,
    length: { maximum: 50 }

  validates :email,
    presence: true,
    uniqueness: { case_sensitive: false },
    length: { maximum: 255 },
    format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :status, presence: true, inclusion: { in: statuses.keys }

  validates :senha, length: { minimum: 8, maximum: 72 }, allow_blank: true

  validate :senha_obrigatoria_para_usuario_ativo

  def administrador?
    perfil_adm.present?
  end

  def docente?
    perfil_docente.present?
  end

  def discente?
    perfil_discente.present?
  end

  def participante?
    docente? || discente?
  end

  def pode_acessar_sistema?
    ativo? && senha_digest.present?
  end

  private

  def normalizar_email
    self.email = email.to_s.strip.downcase if email.present?
  end

  def normalizar_matricula
    self.matricula = matricula.to_s.strip if matricula.present?
  end

  def senha_obrigatoria_para_usuario_ativo
    return unless ativo?
    return if senha_digest.present? || senha.present?

    errors.add(:senha, "deve ser definida para ativar o usuário")
  end
end
