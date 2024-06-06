class Departamento < ApplicationRecord
    validates :nome, presence: true
  end
  