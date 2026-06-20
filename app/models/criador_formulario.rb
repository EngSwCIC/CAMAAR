class CriadorFormulario < ApplicationRecord
  belongs_to :usuario
  has_many :template_formularios
  has_many :formularios
end
