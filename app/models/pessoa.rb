class Pessoa < ApplicationRecord
  self.primary_key = 'usuario'
  has_secure_password 
  has_one :discente, foreign_key: 'pessoa_id', dependent: :destroy
  has_one :docente, foreign_key: 'pessoa_id', dependent: :destroy
  has_many :templates, foreign_key: 'pessoa_id', dependent: :destroy
end