class QuestaoTemplate < ApplicationRecord
  self.table_name = "questoes_template"

  belongs_to :template
  has_many :resposta_itens, class_name: "RespostaItem", foreign_key: :questao_template_id, dependent: :destroy

  # Retorna o enunciado da questão.
  #
  # = Parâmetros:
  # * Nenhum.
  #
  # = Retorno:
  # * Retorna uma string com o texto do enunciado.
  #
  # = Efeitos Colaterais:
  # * Nenhum.
  def texto
    enunciado
  end

  # Support Hash-like access for view compatibility with pregunta["texto"]
  # Permite acesso ao objeto como um Hash, retornando atributos específicos.
  #
  # = Parâmetros:
  # * +key+ - A chave ou atributo a ser acessado (ex: "texto" ou "tipo").
  #
  # = Retorno:
  # * Retorna o valor do atributo correspondente ou chama super.
  #
  # = Efeitos Colaterais:
  # * Nenhum.
  def [](key)
    if key.to_s == "texto"
      enunciado
    elsif key.to_s == "tipo"
      tipo
    else
      super
    end
  end
end
