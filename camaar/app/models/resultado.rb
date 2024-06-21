class Resultado < ApplicationRecord
  belongs_to :dicente
  belongs_to :formulario

  has_many :respostas, dependent: :destroy, class_name: "Resposta"
  accepts_nested_attributes_for :respostas

  validate :todas_as_questoes_respondidas

  private

  def todas_as_questoes_respondidas
    todas_questoes = formulario.questaos.pluck(:id)
    questoes_respondidas = respostas.map(&:questao_id)

    unless todas_questoes.sort == questoes_respondidas.sort
      errors.add(:base, "Responda a todas as questões do formulário.")
    end
  end
end
