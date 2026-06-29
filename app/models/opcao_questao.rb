# app/models/opcao_questao.rb
class OpcaoQuestao < ApplicationRecord
  belongs_to :questao_template

  validates :texto, presence: true
end
