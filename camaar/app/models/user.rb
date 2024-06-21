class User < ApplicationRecord
  has_secure_password

  validates :usuario, presence: true, uniqueness: true
  #validates :senha, presence: true, confirmation: true, length: { minimum: 1 }
end
