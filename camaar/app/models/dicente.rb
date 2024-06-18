class Dicente < User
  has_many :classes

  validates :matricula, presence: true
  validates :curso, presence: true
end
# este modelo é temporário e irá sofrer alterações no futuro para se adequar às especificações do trabalho
