class Aluno < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :email, presence: true, uniqueness: true
  validates :encrypted_password, presence: true
  validates :nome, presence: true
  validates :matricula, presence: true, uniqueness: true
  validates :curso, presence: true
  
  has_and_belongs_to_many :materium
end
