require 'csv'

class Formulario < ApplicationRecord
  belongs_to :ligacao_pergunta
  belongs_to :turma

  has_many :respostas, dependent: :destroy
  has_many :formulario_respondidos, dependent: :destroy


  scope :respondidos, -> { joins(:respostas).distinct }

  scope :validos, -> { where.not(id: invalidos.select(:id)) }
  scope :invalidos, -> { where(nome: "") }

  def generate_csv
    CSV.generate(headers: true) do |csv|
      csv << %w[Pergunta Tipo Resposta]
      respostas.includes(:pergunta).each do |resposta|
        csv << [
          resposta.pergunta&.pergunta,
          resposta.pergunta.tipo,
          resposta.conteudo
        ]
      end
    end
  end

end