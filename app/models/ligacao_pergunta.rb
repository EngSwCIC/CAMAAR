class LigacaoPergunta < ApplicationRecord
  has_many :templates, dependent: :destroy
  has_many :perguntas, dependent: :destroy
  has_many :formularios, dependent: :destroy
end
