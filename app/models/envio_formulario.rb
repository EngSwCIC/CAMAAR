# app/models/envio_formulario.rb
class EnvioFormulario < ApplicationRecord
  belongs_to :formulario
  belongs_to :discente

  has_many :respostas, dependent: :destroy

  validates :formulario_id, uniqueness: {
    scope: :discente_id,
    message: "Você já respondeu este formulário"
  }

  validate :formulario_deve_estar_aberto, on: :create

  before_create { self.enviado_em = Time.current }

  private

  def formulario_deve_estar_aberto
    errors.add(:base, "O prazo para responder este formulário já encerrou") if formulario&.fechado?
  end
end
