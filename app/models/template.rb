# frozen_string_literal: true

# == Schema Information
#
# Table name: templates
#
#  id             :integer          not null, primary key
#  titulo         :string
#  publico_alvo   :integer
#  criado_por_id  :integer          not null
#  disciplina_id  :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Classe responsável por representar templates de formulários
class Template < ApplicationRecord
  belongs_to :criado_por, class_name: 'User'
  belongs_to :disciplina, optional: true
  has_many :pergunta, class_name: 'Perguntum', dependent: :destroy
  has_many :formularios, dependent: :destroy

  enum :publico_alvo, { alunos: 0, professores: 1, coordenadores: 2 }

  validates :titulo, presence: true, length: { minimum: 2 }
  validates :publico_alvo, presence: true

  scope :para_alunos, -> { where(publico_alvo: :alunos) }
  scope :para_professores, -> { where(publico_alvo: :professores) }
  scope :por_admin, ->(user) { where(criado_por: user) }
end
