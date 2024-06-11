class Administrador < User
  has_many :formularios
  has_many :templates
  has_many :turmas

  validates :departamento, presence: true

end
# este modelo é temporário e irá sofrer alterações no futuro para se adequar às especificações do trabalho
