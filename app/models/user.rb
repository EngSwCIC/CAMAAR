class User < ApplicationRecord
  has_many :answers

  def self.find(email)
    find_by(email:)
  end

  def self.authenticate(user_id, password)
    user = find_by(id: user_id)
    return false unless user && user.salt.present?

    hashed_password = BCrypt::Engine.hash_secret(password, user.salt)

    hashed_password == user.password
  end

  def generate_session_key
    self.session_key = SecureRandom.hex(30)
    save
    session_key
  end

  def self.criarUser(email, password, password_confirmation)
    return nil if email.blank? || password.blank? || password_confirmation.blank? || password != password_confirmation

    salt = BCrypt::Engine.generate_salt
    hashed_password = BCrypt::Engine.hash_secret(password, salt)

    create(email:, salt:, password: hashed_password, created_at: Time.current)
  end
end
