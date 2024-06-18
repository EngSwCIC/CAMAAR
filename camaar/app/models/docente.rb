class Docente < ApplicationRecord
  has_many :formularios
  has_many :templates
  has_many :classes
  belongs_to :user

  validates :departamento, presence: true

end
# este modelo é temporário e irá sofrer alterações no futuro para se adequar às especificações do trabalho
