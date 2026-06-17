class Formulario < ApplicationRecord
  belongs_to :turma
  has_many :perguntas, dependent: :destroy
  has_many :respostas, dependent: :destroy

  validates :titulo, presence: true
  validates :deadline, presence: true

  def active?
    deadline > Time.current
  end
end
