# frozen_string_literal: true

# Classe responsável por representar templates de formulários
class Template < ApplicationRecord
  belongs_to :criado_por, class_name: 'User'
  belongs_to :disciplina
  has_many :pergunta, class_name: 'Perguntum', foreign_key: 'template_id', dependent: :destroy
  has_many :formularios, dependent: :destroy

  enum :publico_alvo, { alunos: 0, professores: 1, coordenadores: 2 }

  validates :titulo, presence: true, length: { minimum: 2 }
  validates :publico_alvo, presence: true
  
  scope :para_alunos, -> { where(publico_alvo: :alunos) }
  scope :para_professores, -> { where(publico_alvo: :professores) }
  scope :por_admin, ->(user) { where(criado_por: user) }
end
