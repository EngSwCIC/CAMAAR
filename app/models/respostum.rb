# frozen_string_literal: true

# == Schema Information
#
# Table name: resposta
#
#  id             :integer          not null, primary key
#  uuid_anonimo   :string
#  resposta_texto :text
#  formulario_id  :integer          not null
#  pergunta_id    :integer          not null
#  opcao_id       :integer
#  turma_id       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Classe responsável por representar respostas aos formulários
class Respostum < ApplicationRecord
  self.table_name = 'resposta'

  # Associações
  belongs_to :formulario
  belongs_to :pergunta, class_name: 'Perguntum'
  belongs_to :opcao, class_name: 'OpcoesPerguntum', optional: true
  belongs_to :turma, optional: true

  # Validações
  validates :uuid_anonimo, presence: true
  validates :resposta_texto, presence: true, if: -> { opcao_id.blank? }
  validates :opcao_id, presence: true, if: -> { resposta_texto.blank? }
end
