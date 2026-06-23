class Formulario < ApplicationRecord
  belongs_to :template, optional: true
  belongs_to :course_class, optional: true
  belongs_to :admin, class_name: "User"
  has_many :questaos, dependent: :destroy

  validates :title, presence: { message: "O nome do formulário é obrigatório" }
  validates :template_id, presence: { message: "É necessário escolher um template base" }, on: :create
  validates :course_class_id, presence: { message: "É necessário escolher ao menos uma turma" }, on: :create

  after_initialize { self.status ||= "draft" }
end
