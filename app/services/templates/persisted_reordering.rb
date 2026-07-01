# frozen_string_literal: true

module Templates
  # Prepara utilizações e opções persistidas para reordenação segura.
  #
  # A classe coloca números temporários negativos em registros já existentes
  # antes do update final de nested attributes, evitando colisões com índices
  # únicos de ordenação.
  class PersistedReordering
    BOOLEAN = ActiveModel::Type::Boolean.new

    private_constant :BOOLEAN

    ##
    # Executa a preparação de reordenação para um template.
    #
    # Argumentos:
    # - +template+: template que está sendo atualizado.
    # - +attributes+: atributos aninhados de utilizações de questões recebidos
    #   do formulário.
    #
    # Retorno:
    # - Retorna o resultado de +prepare+.
    #
    # Efeitos colaterais:
    # - Atualiza diretamente o campo +numero+ de utilizações e opções
    #   persistidas.
    # - Não cria nem remove registros.
    def self.prepare(template:, attributes:)
      new(template:, attributes:).prepare
    end

    ##
    # Inicializa a preparação com o template e os atributos do formulário.
    #
    # Argumentos:
    # - +template+: template em edição.
    # - +attributes+: hash, parâmetros ou array de atributos aninhados.
    #
    # Retorno:
    # - Retorna a instância inicializada.
    #
    # Efeitos colaterais:
    # - Normaliza atributos em memória.
    # - Não consulta nem altera o banco de dados.
    def initialize(template:, attributes:)
      @template = template
      @utilizacoes_attributes = nested_values(attributes)
    end

    ##
    # Prepara utilizações de questões e opções para a reordenação.
    #
    # Argumentos:
    # - Não recebe argumentos. Usa dados fornecidos no inicializador.
    #
    # Retorno:
    # - Retorna o resultado de +prepare_opcoes+, a última operação executada.
    #
    # Efeitos colaterais:
    # - Atualiza números temporários de utilizações e opções no banco.
    def prepare
      prepare_utilizacoes
      prepare_opcoes
    end

    private

    attr_reader :template, :utilizacoes_attributes

    ##
    # Atualiza temporariamente o número das utilizações persistidas.
    #
    # Argumentos:
    # - Não recebe argumentos. Usa +template+ e +utilizacoes_attributes+.
    #
    # Retorno:
    # - Retorna a relação processada por +find_each+.
    #
    # Efeitos colaterais:
    # - Atualiza diretamente +numero+ em registros de +UtilizacaoQuestao+.
    def prepare_utilizacoes
      UtilizacaoQuestao
        .where(template_id: template.id, id: ids_for(utilizacoes_attributes))
        .find_each { |utilizacao| renumber(utilizacao) }
    end

    ##
    # Atualiza temporariamente o número das opções persistidas.
    #
    # Argumentos:
    # - Não recebe argumentos. Usa os ids calculados por +option_ids+.
    #
    # Retorno:
    # - Retorna a relação processada por +find_each+.
    #
    # Efeitos colaterais:
    # - Atualiza diretamente +numero+ em registros de +Opcao+.
    def prepare_opcoes
      Opcao
        .where(id: option_ids)
        .find_each { |opcao| renumber(opcao) }
    end

    ##
    # Coleta ids de opções persistidas que serão reordenadas.
    #
    # Argumentos:
    # - Não recebe argumentos. Usa +utilizacoes_attributes+.
    #
    # Retorno:
    # - Retorna um array com ids de opções que possuem id e número.
    #
    # Efeitos colaterais:
    # - Não consulta nem altera o banco de dados.
    def option_ids
      utilizacoes_attributes.flat_map do |attributes|
        ids_for(option_attributes_from(attributes))
      end
    end

    ##
    # Extrai os atributos de opções de uma utilização de questão.
    #
    # Argumentos:
    # - +attributes+: atributos de uma utilização de questão.
    #
    # Retorno:
    # - Retorna uma lista normalizada de atributos de opções.
    # - Retorna +[]+ quando não há opções aninhadas.
    #
    # Efeitos colaterais:
    # - Não consulta nem altera o banco de dados.
    def option_attributes_from(attributes)
      question_attributes = nested_attribute(attributes, :questao_attributes)

      nested_values(nested_attribute(question_attributes, :opcoes_attributes))
    end

    ##
    # Seleciona ids persistidos entre atributos aninhados.
    #
    # Argumentos:
    # - +attributes+: lista de hashes/parâmetros de atributos aninhados.
    #
    # Retorno:
    # - Retorna ids de itens não marcados para destruição que possuem id e
    #   número.
    #
    # Efeitos colaterais:
    # - Não consulta nem altera o banco de dados.
    def ids_for(attributes)
      attributes
        .reject { |item| destroy_attribute?(item) }
        .filter_map { |item| persisted_id_with_number(item) }
    end

    ##
    # Verifica se um item aninhado está marcado para destruição.
    #
    # Argumentos:
    # - +attributes+: atributos do item aninhado.
    #
    # Retorno:
    # - Retorna +true+ quando +:_destroy+ ou +"_destroy"+ representa valor
    #   verdadeiro.
    # - Retorna +false+ nos demais casos.
    #
    # Efeitos colaterais:
    # - Não consulta nem altera o banco de dados.
    def destroy_attribute?(attributes)
      BOOLEAN.cast(nested_attribute(attributes, :_destroy))
    end

    ##
    # Retorna o id de um item persistido que possui número enviado.
    #
    # Argumentos:
    # - +attributes+: atributos do item aninhado.
    #
    # Retorno:
    # - Retorna o id quando há id e número presentes.
    # - Retorna +nil+ quando algum desses campos está ausente.
    #
    # Efeitos colaterais:
    # - Não consulta nem altera o banco de dados.
    def persisted_id_with_number(attributes)
      id = nested_attribute(attributes, :id)
      number = nested_attribute(attributes, :numero)

      id if id.present? && number.present?
    end

    ##
    # Atribui um número temporário negativo a um registro.
    #
    # Argumentos:
    # - +record+: registro ActiveRecord com coluna +numero+ e id persistido.
    #
    # Retorno:
    # - Retorna o resultado de +update_columns+.
    #
    # Efeitos colaterais:
    # - Atualiza diretamente a coluna +numero+ no banco de dados.
    # - Ignora validações e callbacks por usar +update_columns+.
    def renumber(record)
      record.update_columns(numero: -record.id)
    end

    ##
    # Lê um atributo aceitando chaves símbolo ou string.
    #
    # Argumentos:
    # - +attributes+: hash ou parâmetros de origem.
    # - +key+: chave desejada em formato símbolo.
    #
    # Retorno:
    # - Retorna o valor encontrado pela chave símbolo ou string.
    # - Retorna +nil+ quando os atributos estão em branco ou a chave não existe.
    #
    # Efeitos colaterais:
    # - Não consulta nem altera o banco de dados.
    def nested_attribute(attributes, key)
      return if attributes.blank?

      attributes[key] || attributes[key.to_s]
    end

    ##
    # Normaliza atributos aninhados para uma lista iterável.
    #
    # Argumentos:
    # - +attributes+: valor nulo, hash, +ActionController::Parameters+ ou
    #   coleção de atributos.
    #
    # Retorno:
    # - Retorna +[]+ quando +attributes+ está em branco.
    # - Retorna os valores quando recebe hash ou parâmetros.
    # - Retorna +Array(attributes)+ nos demais casos.
    #
    # Efeitos colaterais:
    # - Não consulta nem altera o banco de dados.
    def nested_values(attributes)
      return [] if attributes.blank?
      return attributes.values if attributes.is_a?(Hash)
      return attributes.values if attributes.is_a?(ActionController::Parameters)

      Array(attributes)
    end
  end
end
