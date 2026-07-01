# Representa um modelo reutilizável de formulário criado por um +Administrador+.
#
# Contém um conjunto ordenado de +Elemento+s (questões), cada um com seus
# +Campo+s (opções). Ao ser enviado a turmas, o template é instanciado em
# +Formulario+s com +ElementoForm+s e +CampoForm+s correspondentes.
class Template < ApplicationRecord
  belongs_to :administrador, foreign_key: "usuario_id", class_name: "Administrador"
  has_many :elementos, dependent: :destroy
  accepts_nested_attributes_for :elementos, allow_destroy: true

  validate :validar_titulo
  validate :validar_elementos
  validate :validar_preenchimento

  private

  # Valida que o nome do template não está em branco.
  #
  # @return [void]
  # @note Adiciona erro em +:base+ se o atributo +nome+ estiver vazio.
  def validar_titulo
    if nome.blank?
      errors.add(:base, "Título não pode ficar em branco!")
    end
  end

  # Valida que o template possui pelo menos um elemento não marcado para exclusão.
  #
  # @return [void]
  # @note Adiciona erro em +:base+ se nenhum elemento sobreviver à filtragem de
  #   +marked_for_destruction?+.
  def validar_elementos
    if elementos.reject(&:marked_for_destruction?).empty?
      errors.add(:base, "Template deve ter pelo menos um elemento!")
    end
  end

  # Valida que todos os elementos e seus campos estão devidamente preenchidos.
  #
  # @return [void]
  # @note Adiciona erro em +:base+ e interrompe a execução na primeira violação
  #   encontrada: enunciado de elemento em branco, ou enunciado de campo em branco
  #   quando o tipo do campo não é "Texto". Não é executada se já existirem erros
  #   prévios.
  def validar_preenchimento
    return if errors.any?
    elementos.reject(&:marked_for_destruction?).each do |elemento|
      if elemento.enunciado.blank?
        errors.add(:base, "O texto de todas as questões deve ser preenchido!")
        return # Para a execução aqui para não repetir a mensagem várias vezes
      end

      elemento.campos.reject(&:marked_for_destruction?).each do |campo|
        if campo.tipo_elemento != "Texto" && campo.enunciado.blank?
          errors.add(:base, "Todas as opções das questões devem ser preenchidas!")
          return
        end
      end
    end
  end
end
