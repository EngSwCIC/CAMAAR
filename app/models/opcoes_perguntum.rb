# frozen_string_literal: true

# Classe responsável por representar opções de perguntas
class OpcoesPerguntum < ApplicationRecord
  self.table_name = 'opcoes_pergunta'
  
  belongs_to :pergunta, class_name: 'Perguntum', foreign_key: 'pergunta_id'
  has_many :respostas, class_name: 'Respostum', foreign_key: 'opcao_id', dependent: :destroy
  
  validates :texto, presence: true, length: { minimum: 1 }
end
