class User < ApplicationRecord
  has_secure_password

  # Constants
  RESET_TOKEN_EXPIRATION = 2.hours
  DIGEST_COST = Rails.env.production? ? 12 : 1
  ROLES = %w[admin docente discente].freeze

  has_many :templates, dependent: :destroy
  has_many :template_responses, dependent: :destroy

  validates :ocupacao, inclusion: { in: ROLES }

  # Validações
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :matricula, uniqueness: true, allow_nil: true
  validate :matricula_required_unless_admin_or_docente

  # Password reset methods
  def generate_password_reset_token!
    raw_token = SecureRandom.urlsafe_base64(20)
    digest = generate_digest(raw_token)
    update_columns(
      password_reset_token: digest,
      password_reset_sent_at: Time.zone.now
    )
    raw_token
  end

  def password_reset_token_valid?(raw_token)
    return false unless password_reset_token.present? &&
                        password_reset_sent_at.present? &&
                        raw_token.present?

    authenticated?(:password_reset, raw_token) &&
      password_reset_sent_at >= RESET_TOKEN_EXPIRATION.ago
  end

  def clear_password_reset_token!
    update_columns(
      password_reset_token: nil,
      password_reset_sent_at: nil
    )
  end

  # Authentication methods
  def self.authenticate(login, password)
    user = find_by(email: login) || find_by(matricula: login)
    user&.authenticate(password)
  end

  # Remember me methods
  def remember
    self.remember_token = SecureRandom.urlsafe_base64
    update_column(:remember_digest, generate_digest(remember_token))
    remember_token
  end

  def forget
    update_column(:remember_digest, nil)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil? || token.nil?

    # Prevenção contra timing attacks
    ActiveSupport::SecurityUtils.secure_compare(
      ::BCrypt::Password.new(digest).to_s,
      ::BCrypt::Engine.hash_secret(token, digest)
    )
  end

  # Métodos para verificar papel do usuário
  def admin?
    ocupacao == "admin"
  end

  def docente?
    ocupacao == "docente"
  end

  def discente?
    ocupacao == "discente"
  end

  private

  def generate_digest(token)
    cost = DIGEST_COST
    BCrypt::Password.create(token, cost: cost)
  end

  def matricula_required_unless_admin_or_docente
    if discente? && matricula.blank?
      errors.add(:matricula, "é obrigatória para discentes")
    end
  end
end
