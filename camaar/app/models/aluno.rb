class Aluno < User
  has_and_belongs_to_many :turma

  validates :nome, presence: true
  validates :senha, presence: true
  valdiates :matricula, presence: true
end
# este modelo é temporário e irá sofrer alterações no futuro para se adequar às especificações do trabalho
