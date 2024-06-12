class Turma < ApplicationRecord
  has_many :dicentes
  has_many :formularios
  has_one :docente

  validates :codigo, presence: true;
  validates :nome_materia, presence: true;
  validates :semestre, presence: true;
  validates :horario, presence: true;

end

# este modelo é temporário e irá sofrer alterações no futuro para se adequar às especificações do trabalho
