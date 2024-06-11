class User < ApplicationRecord
  validates :nome, presence: true
  validates :email, presence: true
  validates :senha
  validates :ocupacao, presence: true
  validates :usuario, presence: true
  validates :formacao, presence: true
end
