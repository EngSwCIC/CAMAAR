class Template < ApplicationRecord
  has_many :questoes, class_name: 'Questao', dependent: :destroy
  has_many :avaliacoes, class_name: 'Avaliacao', dependent: :restrict_with_error
  
  accepts_nested_attributes_for :questoes, allow_destroy: true

  validates :titulo, presence: true
  validate :deve_ter_pelo_menos_uma_questao

  private

  def deve_ter_pelo_menos_uma_questao
    if questoes.reject(&:marked_for_destruction?).empty?
      errors.add(:base, "O template requer no mínimo uma questão associada.")
    end
  end
end