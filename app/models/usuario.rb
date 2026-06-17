class Usuario < ApplicationRecord
  self.table_name = "usuarios"

  belongs_to :curso, optional: true
  belongs_to :departamento, optional: true
  has_many :matriculas, dependent: :destroy
  has_many :turmas, through: :matriculas
  has_many :respostas, dependent: :destroy

  attr_reader :password
  attr_accessor :password_confirmation, :validating_password_rules

  validates :email, presence: true

  # Custom password hashing using bcrypt to work with existing 'senha_hash' column
  def authenticate(unencrypted_password)
    return false if senha_hash.blank?
    BCrypt::Password.new(self.senha_hash) == unencrypted_password
  rescue BCrypt::Errors::InvalidHash
    false
  end

  def password=(unencrypted_password)
    @password = unencrypted_password
    self.senha_hash = BCrypt::Password.create(unencrypted_password) if unencrypted_password.present?
  end

  validate :password_security_rules, if: :validating_password_rules

  def pode_gerenciar_turma?(turma)
    departamento_id == turma.departamento_id
  end

  # Helpers to generate tokens
  def generate_setup_token!
    self.setup_token = SecureRandom.hex(20)
    self.setup_token_sent_at = Time.current
    self.setup_token_used = false
    save!
  end

  def generate_reset_token!
    self.reset_token = SecureRandom.hex(20)
    self.reset_token_sent_at = Time.current
    self.reset_token_used = false
    save!
  end

  private

  def password_security_rules
    if password.blank? || password_confirmation.blank?
      errors.add(:password, "Preencha todos os campos obrigatórios")
      return
    end

    if password != password_confirmation
      errors.add(:password, "As senhas não coincidem")
    end

    if password.length < 6
      errors.add(:password, "Senha deve ter no mínimo 6 caracteres")
    end

    unless password.match(/\d/)
      errors.add(:password, "A senha deve conter pelo menos um número")
    end

    if password.match(/[A-Z]/)
      errors.add(:password, "A senha deve conter apenas letras minúsculas")
    end
  end
end
