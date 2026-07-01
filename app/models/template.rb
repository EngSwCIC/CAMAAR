# app/models/template.rb
class Template < ApplicationRecord
  belongs_to :docente

  has_many :questao_templates, dependent: :destroy
  has_many :formularios,       dependent: :restrict_with_error

  validates :titulo, presence: true
end
