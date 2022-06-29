##
# Essa classe representa o model ActiveRecord que armazena o questionário que será 
# respondido pelos membros do corpo dicente para cada Cclass em que estão matriculados

class Survey < ApplicationRecord
  belongs_to :role
  has_many :survey_questions, dependent: :destroy

  ##
  # Método que verifica se a um +Survey+ está fora da validade.
  #
  # Retorna +true+ caso +expiration_date+ seja _menor_ que a data atual e
  # retorna +false+ caso +expiration_date+ seja _maior_ que a data atual.
  def is_expired?
    self.expiration_date <= DateTime.now
  end

end
