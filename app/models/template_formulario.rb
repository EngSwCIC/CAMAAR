class TemplateFormulario < ApplicationRecord
  belongs_to :criador_formulario

  has_many :formularios, dependent: :nullify
  has_many :perguntas, dependent: :destroy
  
  accepts_nested_attributes_for :perguntas, allow_destroy: true, reject_if: :all_blank
end
