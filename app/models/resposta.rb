# app/models/resposta.rb
class Resposta < ApplicationRecord
  belongs_to :envio_formulario
  belongs_to :questao

  validates :conteudo, presence: true
end
