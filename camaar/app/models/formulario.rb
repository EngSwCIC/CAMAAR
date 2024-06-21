class Formulario < ApplicationRecord
  belongs_to :docente
  belongs_to :template

  has_and_belongs_to_many :turmas, join_table: 'formularios_turmas'

  validates :dataDeTermino, presence: true
  validates :nome, presence: true

  validate :dataDeTermino_in_future

  private

  def dataDeTermino_in_future
    if dataDeTermino && dataDeTermino <= Date.today
      errors.add(:dataDeTermino, "deve ser uma data futura")
    end
  end
end
