# frozen_string_literal: true

# Classe responsável por representar respostas aos formulários
class Respostum < ApplicationRecord
  self.table_name = 'resposta'
  
  # Associações
  belongs_to :formulario
  belongs_to :pergunta, class_name: 'Perguntum', foreign_key: 'pergunta_id'
  belongs_to :opcao, class_name: 'OpcoesPerguntum', foreign_key: 'opcao_id', optional: true
  belongs_to :turma, optional: true
  
  # Validações
  validates :uuid_anonimo, presence: true
  validates :resposta_texto, presence: true, if: -> { opcao_id.blank? }
  validates :opcao_id, presence: true, if: -> { resposta_texto.blank? }
end
