class Professor < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :materia, optional: true
  belongs_to :departamento

  validates :nome, :email, :encrypted_password, :is_admin, presence: true
  validates :email, uniqueness: true
end
