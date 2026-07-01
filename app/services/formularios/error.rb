# frozen_string_literal: true

# Namespace de serviços do domínio de formulários.
module Formularios
  # Exceção de negócio levantada por +Formularios::CreateFromTemplate+.
  #
  # A mensagem é exposta ao usuário via controller quando a criação em lote
  # falha por validação de regras de negócio.
  class Error < StandardError
    # Texto descritivo do erro de negócio exposto ao usuário.
    attr_reader :message

    ##
    # Inicializa a exceção com a mensagem exibida ao usuário.
    #
    # Argumentos:
    # - +message+: texto descritivo do erro de negócio.
    #
    # Retorno:
    # - Instância de +Formularios::Error+ com +message+ acessível via
    #   +attr_reader+.
    #
    # Efeitos colaterais:
    # - Modifica o estado interno da exceção ao preencher +@message+.
    # - Não altera o banco de dados.
    def initialize(message)
      @message = message
      super
    end
  end
end
