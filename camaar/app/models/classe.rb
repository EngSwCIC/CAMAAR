class Classe < ApplicationRecord
  belongs_to :disciplina
  belongs_to :docente

  has_many :dicentes
  has_many :formularios_classes, dependent: :destroy
  has_many :formularios, through: :formularios_classes

  validates :class_code, presence: true;
  validates :semestre, presence: true;
  validates :horario, presence: true;

end

# este modelo é temporário e irá sofrer alterações no futuro para se adequar às especificações do trabalho
