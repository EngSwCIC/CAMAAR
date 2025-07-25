# frozen_string_literal: true

# == Schema Information
#
# Table name: opcoes_pergunta
#
#  id           :integer          not null, primary key
#  texto        :string
#  pergunta_id  :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Classe responsável por representar opções de perguntas
class OpcoesPerguntum < ApplicationRecord
  self.table_name = 'opcoes_pergunta'

  belongs_to :pergunta, class_name: 'Perguntum'
  has_many :respostas, class_name: 'Respostum', foreign_key: 'opcao_id', dependent: :destroy

  validates :texto, presence: true, length: { minimum: 1 }
end
