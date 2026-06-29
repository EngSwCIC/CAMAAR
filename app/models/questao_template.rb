# app/models/questao_template.rb
class QuestaoTemplate < ApplicationRecord
  belongs_to :template

  has_many :opcao_questoes, dependent: :destroy
  has_many :questoes,       dependent: :restrict_with_error

  enum :tipo, { aberta: 0, multipla: 1 }

  validates :enunciado, presence: true
  validates :tipo,      presence: true
end
