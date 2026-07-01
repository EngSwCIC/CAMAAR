# Questão pertencente a um Template de formulário
class Question < ApplicationRecord
  belongs_to :template

  serialize :options, coder: JSON

  validates :kind, presence: true, inclusion: { in: %w[radio text escala] }
  validates :text, presence: true
  validate :radio_must_have_options

  private

  # Garante que questões do tipo "radio" possuam ao menos uma opção preenchida
  #
  # Argumentos: Nenhum
  # Retorno: Nenhum
  # Efeitos colaterais: Adiciona erro em :options quando inválido
  def radio_must_have_options
    return unless kind == "radio"
    return if Array(options).any? { |opt| opt.to_s.strip.present? }

    errors.add(:options, "Questões do tipo Radio devem ter ao menos uma opção")
  end
end
