class Option < ApplicationRecord
  belongs_to :survey_question
  has_many :selected_options

  validates :option, presence:true, uniqueness: { scope: :survey_question_id }
  validate :question_is_option

  ##
  # Validação customizada para verificar se a +Question+ é do tipo caixa de seleção,
  # uma vez que é só nesse caso que a questão pode ter opções
  #
  # O método não recebe argumentos
  #
  # Método não retorna nenhum valor
  #
  # Levanta um erro na criação/atualização da model caso a condição não seja satisfeita
  #

  def question_is_option
    if self.survey_question.question_type != "Caixa de Seleção"
      errors.add(:survey_question, "Questão não é do tipo Caixa de Seleção")
    end
  end
end
