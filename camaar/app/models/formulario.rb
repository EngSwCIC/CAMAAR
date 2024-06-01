class Formulario < ApplicationRecord
  has_many :questao, dependant: :destroy
  belongs_to :administrador

  validates :turmas, presence: true
  validates :dataDeTermino, presence: true
  validates :Resultados, presence: true

  validate :dataDeTermino_in_future

  accepts_nested_attributes_for :questao, reject_if: :all_blank, allow_destroy: true

  private

  def dataDeTermino_in_future
    if dataDeTermino <= Date.today
      errors.add(:dataDeTermino, "data inválida")
    end
  end
end
