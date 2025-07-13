class User < ApplicationRecord
  has_secure_password

  # Para recuperação de senha
  attr_accessor :reset_token

  # Gera token para reset de senha
  def generate_password_reset_token!
    self.reset_token = SecureRandom.urlsafe_base64
    update_column(:password_reset_token, Digest::SHA1.hexdigest(reset_token))
    update_column(:password_reset_sent_at, Time.zone.now)
  end

  # Verifica se o token de reset é válido (2 horas de validade)
  def password_reset_token_valid?
    password_reset_sent_at.present? && password_reset_sent_at > 2.hours.ago
  end

  # Limpa o token após uso
  def clear_password_reset_token!
    update_columns(password_reset_token: nil, password_reset_sent_at: nil)
  end

  # Para "Lembrar-me"
  def remember
    self.remember_token = SecureRandom.urlsafe_base64
    update_column(:remember_digest, Digest::SHA1.hexdigest(remember_token))
  end

  def forget
    update_column(:remember_digest, nil)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
end