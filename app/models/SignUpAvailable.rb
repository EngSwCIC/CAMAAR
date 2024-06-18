class SignUpAvailable < ApplicationRecord
    def self.check_availability(email, key)
      exists?(email: email, key: key)
    end
end  