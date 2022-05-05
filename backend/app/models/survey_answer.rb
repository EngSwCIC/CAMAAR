class SurveyAnswer < ApplicationRecord
  belongs_to :survey
  belongs_to :enrollment
  has_many :answers

  validate :member_is_docente

  ##
  # Validação customizada para verificar se o +Member+ é um Docente,
  # uma vez que é só nesse caso que o membro pode responder o questionário
  #
  # O método não recebe argumentos
  #
  # Método não retorna nenhum valor
  #
  # Levanta um erro na criação/atualização da model caso a condição não seja satisfeita
  #

  def member_is_docente
    if self.enrollment.member.occupation != "docente"
      errors.add(:enrollment, "Membro associado não é um docente")
    end
  end
end
