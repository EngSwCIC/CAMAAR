class Turma < ApplicationRecord
  has_many :alunos
  has_many :formularios

  validates :nome_professor, presence: true;
  validates :nome_materia, presence: true;
  validates :semestre, presence: true;
end

# este modelo é temporário e irá sofrer alterações no futuro para se adequar às especificações do trabalho
