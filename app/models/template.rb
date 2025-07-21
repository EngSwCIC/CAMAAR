class Template < ApplicationRecord
  belongs_to :ligacao_pergunta
  has_many :perguntas, through: :ligacao_pergunta
  accepts_nested_attributes_for :perguntas
end