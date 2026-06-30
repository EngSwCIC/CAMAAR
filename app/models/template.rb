## 
# Define a model para representar um template de formulário, incluindo validações e métodos auxiliares para gerenciar questões associadas, incluindo validação de FK nas operações.
# == Schema:
#  * id: integer, primary key
#  * nome: string, nome do template
class Template < ApplicationRecord
  # Ordem importa: as respostas têm FK para questions. Os formulários (e suas
  # respostas) precisam ser destruídos ANTES das questions, senão a remoção
  # das questions viola a FK das respostas. Por isso :formularios vem primeiro.
  has_many :formularios, dependent: :destroy
  has_many :questions, dependent: :destroy, inverse_of: :template
  accepts_nested_attributes_for :questions,
                                allow_destroy: true,
                                reject_if: ->(attrs) { attrs["enunciado"].blank? }

  validates :nome, presence: true

  # Busca por nome. Filtra a listagem quando
  # houver termo; sem termo, retorna todos.
  scope :search, ->(termo) {
    if termo.present?
      where("nome LIKE ?", "%#{sanitize_sql_like(termo)}%")
    else
      all
    end
  }
end
