class Docente < ApplicationRecord
  has_many :formularios, class_name: 'Formulario'
  has_many :templates, class_name: 'Template'
  has_many :turmas, class_name: 'Turma'
  belongs_to :user

  validates :departamento, presence: true

end
# este modelo é temporário e irá sofrer alterações no futuro para se adequar às especificações do trabalho
