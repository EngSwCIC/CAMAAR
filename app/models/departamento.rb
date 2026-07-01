# app/models/departamento.rb
class Departamento < ApplicationRecord
  has_many :admins, dependent: :restrict_with_error
  has_many :users, through: :admins
  has_many :turmas, dependent: :destroy

  validates :nome, presence: true, uniqueness: true
end
