class Formulario < ApplicationRecord
  belongs_to :turma
  belongs_to :template, optional: true
  has_many :questoes, dependent: :destroy
  enum status: { aberto: 0, fechado: 1 }
end