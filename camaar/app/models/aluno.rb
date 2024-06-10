class Aluno < User
  belongs_to :turma, class_name: "turma", foreign_key: "turma_id"

  validates :nome, presence: true
  validates :senha, presence: true
  valdiates :matricula, presence: true
end
# este modelo é temporário e irá sofrer alterações no futuro para se adequar às especificações do trabalho
