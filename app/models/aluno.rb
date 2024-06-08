class Aluno < ApplicationRecord
  validates :nome, presence: true
  validates :matricula, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :encrypted_password, presence: true
  validates :curso, presence: true

 has_many :materium
 belongs_to :materium
end

