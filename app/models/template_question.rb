##
# Pergunta individual dentro de um template de avaliação
#
# Cada pergunta tem um tipo específico que determina como será renderizada
# e como as respostas serão coletadas dos usuários.
#
# === Tipos de Pergunta
# * +text+: Campo de texto livre para respostas abertas
# * +radio+: Botões de opção para escolha única
# * +checkbox+: Caixas de seleção para múltipla escolha
# * +scale+: Escala numérica (tipicamente 1-5)
#
# === Associações
# * Pertence a um Template
# * Tem muitas QuestionAnswer (respostas individuais)
#
# === Exemplo de uso
#
#   # Pergunta de escala
#   question = template.template_questions.create!(
#     question_text: "Como você avalia o professor?",
#     question_type: "scale",
#     required: true,
#     position: 1
#   )
#
#   # Pergunta de múltipla escolha com opções
#   question = template.template_questions.create!(
#     question_text: "Qual seu curso?",
#     question_type: "radio",
#     options: ["Ciência da Computação", "Engenharia de Software", "Outro"].to_json,
#     required: true,
#     position: 2
#   )
#
class TemplateQuestion < ApplicationRecord
  belongs_to :template
  has_many :question_answers, dependent: :destroy

  validates :question_text, presence: true
  validates :question_type, presence: true,
            inclusion: { in: %w[text radio checkbox scale] }

  ##
  # Ordena perguntas por posição para exibição sequencial
  scope :ordered, -> { order(:position) }

  ##
  # Converte opções JSON em array Ruby
  #
  # Para perguntas de múltipla escolha, as opções são armazenadas como JSON.
  # Este método facilita o acesso às opções como array.
  #
  # === Retorno
  # +Array+:: Array de strings com as opções ou array vazio
  #
  # === Exemplo
  #   question.options_array  # => ["Opção 1", "Opção 2", "Opção 3"]
  def options_array
    return [] if options.blank?
    JSON.parse(options) rescue []
  end

  ##
  # Define opções a partir de um array
  #
  # Converte array de opções em JSON para armazenamento.
  #
  # === Parâmetros
  # +value+:: Array de strings com as opções
  #
  # === Exemplo
  #   question.options_array = ["Sim", "Não", "Talvez"]
  #   question.save
  def options_array=(value)
    self.options = value.to_json
  end
end
