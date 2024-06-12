class User < ApplicationRecord
  # Inclua os módulos do Devise necessários
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  #enum role: [:docente, :dicente]

  validates :nome, presence: true
  validates :email, presence: true
  validates :senha, presence: true
  validates :type, presence: true
  validates :usuario, presence: true
  validates :formacao, presence: true
end
