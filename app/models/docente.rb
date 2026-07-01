# app/models/docente.rb
class Docente < ApplicationRecord
  belongs_to :usuario
  belongs_to :departamento

  has_many :turmas,    dependent: :restrict_with_error
  has_many :templates, dependent: :restrict_with_error

  delegate :nome, :email, to: :usuario
end
