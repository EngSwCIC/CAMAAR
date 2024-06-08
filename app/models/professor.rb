class Professor < ApplicationRecord
  validates :nome, presence: true
  validates :email, presence: true, uniqueness: true
  validates :isadmin, inclusion: { in: [true, false] }
  validates :encrypted_password, presence: true

  belongs_to :departamento
  has_many :materium
  belongs_to :materium
end
