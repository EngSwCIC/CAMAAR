class Departamento < ApplicationRecord
  validates :nome, presence: true
  
  has_many :professors
  has_many :materium

  end
  