class Resultado < ApplicationRecord
  belongs_to :dicente
  belongs_to :formulario
  has_many :respostas, dependent: :destroy

  accepts_nested_attributes_for :respostas

  validates :nota, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :todas_as_questoes_respondidas

  def calcular_nota
    total_pontos = 0

    respostas.each do |resposta|
      questao = resposta.questao

      if questao.tipo.discursiva?
        # Lógica para questões discursivas
        # Exemplo: Comparar resposta do aluno com a resposta esperada
        if resposta.conteudo == questao.alternativaCorreta
          total_pontos += questao.pontos
        end
      else
        # Lógica para questões de múltipla escolha
        # Exemplo: Verificar se a alternativa escolhida pelo aluno está correta
        alternativa_correta = questao.alternativas.find_by(correta: true)

        if resposta.conteudo.to_i == alternativa_correta.id
          total_pontos += questao.pontos
        elsif questao.fatorDeCorrecao != 0
          total_pontos -= questao.fatorDeCorrecao
        end
      end
    end

    self.nota = total_pontos
  end

  private

  def todas_as_questoes_respondidas
    todas_questoes = formulario.questaos.pluck(:id)
    questoes_respondidas = respostas.map(&:questao_id)

    unless todas_questoes.sort == questoes_respondidas.sort
      errors.add(:base, "Responda a todas as questões do formulário.")
    end
  end
end
