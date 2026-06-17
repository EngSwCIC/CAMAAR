class Template < ApplicationRecord
  belongs_to :administrador, foreign_key: "usuario_id", class_name: "Administrador"
  has_many :elementos, dependent: :destroy
  accepts_nested_attributes_for :elementos, allow_destroy: true

  validate :validar_titulo
  validate :validar_elementos
  validate :validar_preenchimento

  private

  def validar_titulo
    if nome.blank?
      errors.add(:base, "Título não pode ficar em branco!")
    end
  end

  def validar_elementos
    if elementos.reject(&:marked_for_destruction?).empty?
      errors.add(:base, "Template deve ter pelo menos um elemento!")
    end
  end

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
