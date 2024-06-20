class Professor < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :email, presence: true
  validates :encrypted_password, presence: true
  validates :nome, presence: true
  validates :isadmin, inclusion: { in: [true, false] }
  validates :departamento_id, presence: true

  belongs_to :departamento
  has_and_belongs_to_many :materium
end
