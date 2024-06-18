class SignUpAvailable < ApplicationRecord
  def self.check_availability(email, key)
    exists?(email: email, key: key)
  end
  
  def self.create_by_json(email)
    unless SignUpAvailable.exists?(email: email)
      create(email: email, key: "TOKEN_587")
    end
  end
end
