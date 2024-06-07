class Template < ApplicationRecord
  belongs_to :coordinator

  validates :name, presence: { message: "Template precisa de um nome" }, allow_blank: false
end
