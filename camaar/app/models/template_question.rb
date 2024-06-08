class TemplateQuestion < ApplicationRecord
  has_one :template

  validates :title, presence: { message: "Questão precisa de um título" }, allow_blank: false
  validates :question_type, presence: { message: "Tipo da questão não foi especificado" }, allow_blank: false
end
