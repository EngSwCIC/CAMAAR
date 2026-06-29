# app/models/formulario.rb
class Formulario < ApplicationRecord
  belongs_to :turma
  belongs_to :template

  has_many :questoes,          dependent: :destroy
  has_many :envio_formularios, dependent: :destroy

  validates :titulo, presence: true

  scope :abertos,  -> { where("prazo IS NULL OR prazo > ?", Time.current) }
  scope :fechados, -> { where("prazo IS NOT NULL AND prazo <= ?", Time.current) }

  def aberto?
    prazo.nil? || prazo > Time.current
  end

  def fechado?
    !aberto?
  end

  def status_label
    aberto? ? "Aberto" : "Encerrado"
  end

  def respondido_por?(discente)
    envio_formularios.exists?(discente: discente)
  end
end
