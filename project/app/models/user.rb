class User < ApplicationRecord
  PASSWORD_SETUP_TTL = 7.days
  PASSWORD_RESET_TTL = 2.hours

  belongs_to :department, optional: true
  has_many :class_memberships, dependent: :destroy
  has_many :course_classes, through: :class_memberships

  has_secure_password validations: false

  enum :role, { admin: 0, participant: 1 }

  normalizes :email, with: ->(email) { email.strip.downcase }
  normalizes :registration, with: ->(registration) { registration.strip }

  validates :name, :email, :registration, :role, presence: true
  validates :email, uniqueness: true
  validates :registration, uniqueness: true

  def self.find_for_login(identifier)
    normalized = identifier.to_s.strip
    find_by(email: normalized.downcase) || find_by(registration: normalized)
  end

  def self.find_by_setup_token(token)
    find_valid_token(:password_setup_token_digest, :password_setup_sent_at, token, PASSWORD_SETUP_TTL)
  end

  def self.find_by_reset_token(token)
    find_valid_token(:password_reset_token_digest, :password_reset_sent_at, token, PASSWORD_RESET_TTL)
  end

  def password_defined?
    password_digest.present?
  end

  def pending_password_setup?
    !password_defined?
  end

  def generate_password_setup_token!
    token = SecureRandom.urlsafe_base64(32)
    update!(password_setup_token_digest: self.class.token_digest(token), password_setup_sent_at: Time.current)
    token
  end

  def generate_password_reset_token!
    token = SecureRandom.urlsafe_base64(32)
    update!(password_reset_token_digest: self.class.token_digest(token), password_reset_sent_at: Time.current)
    token
  end

  def apply_new_password!(new_password)
    update!(
      password: new_password,
      password_setup_token_digest: nil,
      password_setup_sent_at: nil,
      password_reset_token_digest: nil,
      password_reset_sent_at: nil
    )
  end

  def self.token_digest(token)
    Digest::SHA256.hexdigest(token.to_s)
  end

  def self.find_valid_token(digest_column, sent_at_column, token, ttl)
    user = find_by(digest_column => token_digest(token))
    return unless user
    return if user.public_send(sent_at_column).blank?
    return if user.public_send(sent_at_column) < ttl.ago

    user
  end
  private_class_method :find_valid_token
end
