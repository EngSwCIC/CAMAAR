# Helper de apresentação para as telas de templates.
module TemplatesHelper
  ##
  # Converte o número de uma opção em rótulo alfabético.
  #
  # Argumentos:
  # - +numero+: número da opção. Pode ser inteiro, string numérica ou valor em
  #   branco.
  #
  # Retorno:
  # - Retorna uma string vazia quando +numero+ não representa valor positivo.
  # - Retorna letras minúsculas no estilo de planilha para números positivos,
  #   como +"a"+, +"b"+, +"z"+, +"aa"+.
  #
  # Efeitos colaterais:
  # - Não altera estado nem persiste dados.
  def letra_da_opcao(numero)
    numero = numero.to_i
    return "" unless numero.positive?

    quotient, remainder = (numero - 1).divmod(26)

    "#{letra_da_opcao(quotient)}#{(97 + remainder).chr}"
  end
end
