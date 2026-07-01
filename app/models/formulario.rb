# app/models/formulario.rb
class Formulario < ApplicationRecord
  belongs_to :turma
  belongs_to :template

  has_many :questoes,          dependent: :destroy
  has_many :envio_formularios, dependent: :destroy

  validates :titulo, presence: true

  scope :abertos,  -> { where("prazo IS NULL OR prazo > ?", Time.current) }
  scope :fechados, -> { where("prazo IS NOT NULL AND prazo <= ?", Time.current) }

  # Verifica se o formulário ainda está aberto para respostas.
  #
  # @return [Boolean] true quando não há prazo definido ou quando o prazo ainda não expirou
  def aberto?
    prazo.nil? || prazo > Time.current
  end

  # Verifica se o formulário está encerrado para respostas.
  #
  # @return [Boolean] true quando o formulário não está mais aberto
  def fechado?
    !aberto?
  end

  # Retorna o texto de status exibido para o formulário.
  #
  # @return [String] "Aberto" quando o formulário aceita respostas, ou "Encerrado" caso contrário
  def status_label
    aberto? ? "Aberto" : "Encerrado"
  end

  # Verifica se o formulário já foi respondido por um discente específico.
  #
  # @param discente [Discente] discente que será consultado
  # @return [Boolean] true quando existe envio do discente para este formulário
  def respondido_por?(discente)
    envio_formularios.exists?(discente: discente)
  end
end
