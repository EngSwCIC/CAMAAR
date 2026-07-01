# Application user: both docentes (role "admin") and discentes (role
# "user"). Authenticates via Devise using either e-mail or matrícula
# (Issue #104 - Sistema de Login).
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Virtual attribute holding the raw login value (e-mail or matrícula)
  # submitted on the sign-in form; not persisted.
  attr_accessor :login

  ROLES = %w[admin user].freeze

  has_many :turma_alunos, foreign_key: :aluno_id, dependent: :destroy
  has_many :turmas, through: :turma_alunos
  has_many :respostas, dependent: :destroy
  validates :name, presence: true
  validates :role, inclusion: { in: ROLES }, allow_nil: true
  validates :matricula, uniqueness: true, allow_nil: true

  # Devise authentication hook: finds the user whose e-mail or matrícula
  # (case-insensitive, trimmed) matches the submitted +:login+.
  #
  # +warden_conditions+ - hash with the sign-in params, including +:login+.
  # Returns the matching +User+, or +nil+ if none is found.
  # No side effects (read-only query).
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)&.strip&.downcase
    where(conditions.to_h).where(
      'lower(email) = :value OR lower(matricula) = :value', value: login
    ).first
  end

  # Whether this user has the "admin" role.
  #
  # Returns +true+ or +false+. No side effects.
  def admin?
    role == 'admin'
  end

  # Whether this user has not yet defined a password after being imported.
  #
  # Returns +true+ or +false+. No side effects.
  def first_access?
    first_access
  end

  # Opposite of #first_access? - whether the user already has a password.
  #
  # Returns +true+ or +false+. No side effects.
  def password_defined?
    !first_access?
  end

  # Whether this user must go through the password-reset flow before
  # logging in. Currently equivalent to #first_access?.
  #
  # Returns +true+ or +false+. No side effects.
  def needs_password_reset?
    first_access?
  end
end
