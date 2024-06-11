class User < ApplicationRecord  
  def self.find(email)
    return find_by(email: email)
  end

  def self.authenticate(user_id, password)
    user = find_by(id: user_id)
    return false unless user && user.salt.present?
    
    hashed_password = BCrypt::Engine.hash_secret(password, user.salt)
    
    return hashed_password == user.password
  end
  
  def generate_session_key
    self.session_key = SecureRandom.hex(30)
    save
    return session_key
  end

  def self.criarUser(email, password, password_confirmation)
    return nil unless password == password_confirmation

    salt = BCrypt::Engine.generate_salt
    hashed_password = BCrypt::Engine.hash_secret(password, salt)
    
    create(email: email, salt: salt, password: hashed_password, created_at: Time.current)
  end
end