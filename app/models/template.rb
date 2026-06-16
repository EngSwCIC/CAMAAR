class Template < ApplicationRecord
  has_many :questions, dependent: :destroy, inverse_of: :template
  accepts_nested_attributes_for :questions,
                                allow_destroy: true,
                                reject_if: ->(attrs) { attrs["enunciado"].blank? }

  validates :nome, presence: true

  # Busca por nome (issue #1 "Buscar template"). Filtra a listagem quando
  # houver termo; sem termo, retorna todos.
  scope :search, ->(termo) {
    if termo.present?
      where("nome LIKE ?", "%#{sanitize_sql_like(termo)}%")
    else
      all
    end
  }
end
