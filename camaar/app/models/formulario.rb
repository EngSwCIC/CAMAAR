class Formulario < ApplicationRecord
  belongs_to :docente
  has_one :template

  has_many :formularios_classes, dependent: :destroy
  has_many :classes, through: :formularios_classes
  has_many :resultados, dependant: :destroy

  validates :dataDeTermino, presence: true
  validates :nome, presence: true

  validate :dataDeTermino_in_future

  private

  def dataDeTermino_in_future
    if dataDeTermino <= Date.today
      errors.add(:dataDeTermino, "data inválida")
    end
  end
end
