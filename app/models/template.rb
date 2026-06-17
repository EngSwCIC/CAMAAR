class Template < ApplicationRecord
  belongs_to :pessoa, foreign_key: 'pessoa_id', primary_key: 'usuario'
  has_many :template_questoes, dependent: :destroy
  has_many :formularios, dependent: :nullify
  accepts_nested_attributes_for :template_questoes, allow_destroy: true
  validates :nome, presence: true
end