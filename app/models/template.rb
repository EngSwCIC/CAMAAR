# Representa um template de formulário criado por um administrador.
# Um template contém questões modelo que são copiadas ao gerar formulários.
class Template < ApplicationRecord
  belongs_to :pessoa, foreign_key: 'pessoa_id', primary_key: 'usuario'
  has_many :template_questoes, dependent: :destroy
  has_many :formularios, dependent: :nullify
  accepts_nested_attributes_for :template_questoes, allow_destroy: true
  validates :nome, presence: true
end
