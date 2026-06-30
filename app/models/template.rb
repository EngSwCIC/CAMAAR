class Template < ApplicationRecord
  self.table_name = "templates"

  belongs_to :criador, class_name: "Usuario", foreign_key: "criador_id"
  has_many :perguntas, class_name: "QuestaoTemplate", dependent: :destroy
  has_many :formularios, dependent: :destroy

  attr_accessor :skip_questions_validation

  validates :titulo, presence: { message: "Nome do Template não pode ficar em branco" }
  validate :must_have_at_least_one_question

  private

  # Valida se o template tem pelo menos uma pergunta, a menos que seja ignorado.
  #
  # = Parâmetros:
  # * Nenhum.
  #
  # = Retorno:
  # * Nil.
  #
  # = Efeitos Colaterais:
  # * Adiciona erro de validação ao model.
  def must_have_at_least_one_question
    return if skip_questions_validation
    if perguntas.empty?
      errors.add(:base, "O template deve ter ao menos uma pergunta")
    end
  end
end
