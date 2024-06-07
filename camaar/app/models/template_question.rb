class TemplateQuestion < ApplicationRecord
  has_one :template

  validates :title, presence: { message: "Questão precisa de um título" }, allow_blank: false
  validates :question_type, presence: { message: "Tipo da questão não foi especificado" }, allow_blank: false, numericality: { greater_than_or_equal_to: 1, message: "Escolha o tipo da questão" }
  validates :body, presence: { message: "Corpo da função foi mal definido" }, allow_blank: false
end
