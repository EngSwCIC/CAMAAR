# frozen_string_literal: true

module Formularios
  # Copia questões e opções de um template para um formulário.
  #
  # A cópia cria um snapshot independente, evitando que mudanças futuras no
  # template alterem formulários já publicados.
  class TemplateQuestionSnapshot
    ##
    # Copia as questões de um template para um formulário.
    #
    # Argumentos:
    # - +template+: template usado como origem das questões.
    # - +formulario+: formulário que receberá as cópias.
    #
    # Retorno:
    # - Retorna o resultado de +copy+, normalmente a coleção iterada de
    #   utilizações de questões.
    #
    # Efeitos colaterais:
    # - Cria questões e opções associadas ao formulário.
    # - Persiste cada questão copiada no banco de dados.
    def self.copy(template:, formulario:)
      new(template:, formulario:).copy
    end

    ##
    # Inicializa o copiador de snapshot.
    #
    # Argumentos:
    # - +template+: template de origem.
    # - +formulario+: formulário de destino.
    #
    # Retorno:
    # - Retorna a instância inicializada.
    #
    # Efeitos colaterais:
    # - Apenas armazena referências em memória.
    # - Não consulta nem altera o banco de dados.
    def initialize(template:, formulario:)
      @template = template
      @formulario = formulario
    end

    ##
    # Copia todas as questões raiz ordenadas do template.
    #
    # Argumentos:
    # - Não recebe argumentos. Usa +template+ e +formulario+ do inicializador.
    #
    # Retorno:
    # - Retorna a coleção iterada de utilizações de questões.
    #
    # Efeitos colaterais:
    # - Consulta as questões do template.
    # - Cria e persiste questões e opções copiadas para o formulário.
    def copy
      template.utilizacoes_questoes.raizes.ordenadas.each do |utilizacao|
        copy_question(utilizacao.questao)
      end
    end

    private

    attr_reader :template, :formulario

    ##
    # Copia uma questão individual para o formulário.
    #
    # Argumentos:
    # - +source+: questão de origem pertencente ao template.
    #
    # Retorno:
    # - Retorna +true+ quando a questão copiada é salva com sucesso.
    # - Levanta exceção ActiveRecord se a cópia for inválida.
    #
    # Efeitos colaterais:
    # - Cria uma questão associada ao formulário.
    # - Copia opções em memória antes de persistir a questão.
    # - Persiste a nova questão e suas opções no banco.
    def copy_question(source)
      question = formulario.questoes.build(
        enunciado: source.enunciado,
        tipo: source.tipo
      )

      copy_options(question, source)
      question.save!
    end

    ##
    # Copia as opções de uma questão objetiva.
    #
    # Argumentos:
    # - +question+: questão de destino recém-construída.
    # - +source+: questão de origem cujas opções serão copiadas.
    #
    # Retorno:
    # - Retorna a coleção de opções de origem iterada pelo +each+.
    #
    # Efeitos colaterais:
    # - Adiciona opções em memória à questão de destino.
    # - Não persiste diretamente; a persistência ocorre ao salvar a questão.
    def copy_options(question, source)
      source.opcoes.ordenadas.each do |option|
        question.opcoes.build(numero: option.numero, texto: option.texto)
      end
    end
  end
end
