class Pergunta < ApplicationRecord
  belongs_to :ligacao_pergunta
  has_many :opcoes, foreign_key: 'pergunta_id', dependent: :destroy
  has_many :respostas, dependent: :destroy
end
