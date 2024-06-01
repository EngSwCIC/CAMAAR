class Turma < ApplicationRecord
  has_many :alunos
  has_many :formularios

  validates :nome, presence: true;
end

# este modelo é temporário e irá sofrer alterações no futuro para se adequar às especificações do trabalho
