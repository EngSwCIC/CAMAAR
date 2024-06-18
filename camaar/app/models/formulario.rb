class Formulario < ApplicationRecord
  belongs_to :docente
  has_one :template
  has_many :resultados, dependant: :destroy

  has_many :formulario_classes, dependent: :destroy
  has_many :classes, through: :formulario_turmas

  validates :classe_id, presence: true
  validates :dataDeTermino, presence: true
  validates :Resultados, presence: true

  validate :dataDeTermino_in_future

  private

  def dataDeTermino_in_future
    if dataDeTermino <= Date.today
      errors.add(:dataDeTermino, "data inválida")
    end
  end
end
