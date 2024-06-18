class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  #enum role: [:docente, :dicente]

  validates :nome, presence: true
  validates :email, presence: true
  validates :password, presence: true
  validates :type, presence: true
  validates :usuario, presence: true
  validates :formacao, presence: true
end
