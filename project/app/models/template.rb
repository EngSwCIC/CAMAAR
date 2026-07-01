##
# Representa um modelo reutilizável de formulário criado por um administrador.
class Template < ApplicationRecord
  belongs_to :admin, class_name: "User"
  has_many :questaos, dependent: :destroy
  has_many :formularios, dependent: :nullify

  validates :title, presence: { message: "O nome do template é obrigatório" }
end
