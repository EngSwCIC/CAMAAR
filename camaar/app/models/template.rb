class Template < ApplicationRecord
  belongs_to :coordinator
  has_many :template_question, dependent: :delete_all
  validates :name, presence: { message: "Template precisa de um nome" }, allow_blank: false
end
