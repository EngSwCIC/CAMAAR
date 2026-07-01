# Resposta enviada por um usuário para uma questão de uma avaliação.
class Resposta < ApplicationRecord
  belongs_to :user
  belongs_to :avaliacao
  belongs_to :questao

  validates :texto, presence: true
  validates :questao_id, uniqueness: { scope: [:user_id, :avaliacao_id] }

  # Persiste um conjunto de respostas quando todas são válidas.
  #
  # +respostas+ - array de objetos +Resposta+ montados em memória.
  # Retorna +true+ quando o array não está vazio e todos os registros são
  # válidos e salvos; retorna +false+ quando está vazio ou contém algum item
  # inválido. Pode alterar o banco de dados ao salvar registros válidos.
  def self.salvar_lote(respostas)
    return false if respostas.empty?
    return false unless respostas.all?(&:valid?)

    respostas.all?(&:save)
  end
end
