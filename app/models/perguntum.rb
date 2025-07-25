# frozen_string_literal: true

# == Schema Information
#
# Table name: pergunta
#
#  id          :integer          not null, primary key
#  texto       :string
#  tipo        :integer
#  template_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Classe responsável por representar perguntas dos formulários
class Perguntum < ApplicationRecord
  self.table_name = 'pergunta'

  belongs_to :template
  has_many :opcoes_pergunta, class_name: 'OpcoesPerguntum', foreign_key: 'pergunta_id', dependent: :destroy
  has_many :respostas, class_name: 'Respostum', foreign_key: 'pergunta_id', dependent: :destroy

  # Enum para tipos de pergunta: 0 = verdadeiro_falso, 1 = multipla_escolha, 2 = subjetiva
  enum :tipo, { verdadeiro_falso: 0, multipla_escolha: 1, subjetiva: 2 }

  validates :texto, presence: true, length: { minimum: 3 }
  validates :tipo, presence: true

  scope :ordenadas, -> { order(:id) }

  alias_attribute :titulo, :texto
  attr_accessor :ordem

  # Verifica se a pergunta é de múltipla escolha ou verdadeiro/falso.
  #
  # ==== Returns
  #
  # * +Boolean+ - Retorna true se o tipo da pergunta for 'multipla_escolha' ou 'verdadeiro_falso', caso contrário, retorna false.
  #
  def multipla_escolha_ou_verdadeiro_falso?
    multipla_escolha? || verdadeiro_falso?
  end # Map virtual attributes before assignment

  def assign_attributes(new_attributes)
    return super unless new_attributes.is_a?(Hash)

    attrs = new_attributes.dup
    attrs[:texto] = attrs.delete(:titulo) if attrs.key?(:titulo)
    attrs.delete(:ordem)

    super(attrs)
  end

  # Custom setter for tipo to handle numeric strings
  #
  # ==== Attributes
  #
  # * +value+ - O valor do tipo a ser definido, pode ser uma string numérica ou um inteiro.
  #
  def tipo=(value)
    if value.is_a?(String) && value.match?(/^\d+$/)
      tipo_int = value.to_i
      case tipo_int
      when 0
        super('verdadeiro_falso')
      when 1
        super('multipla_escolha')
      when 2
        super('subjetiva')
      else
        super
      end
    elsif value.is_a?(Integer)
      case value
      when 0
        super('verdadeiro_falso')
      when 1
        super('multipla_escolha')
      when 2
        super('subjetiva')
      else
        super
      end
    else
      super
    end
  end
end
