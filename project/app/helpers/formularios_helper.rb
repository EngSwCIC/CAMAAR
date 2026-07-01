##
# Formata valores de respostas para apresentação nas telas e exportações de formulários.
module FormulariosHelper
  ##
  # Converte uma resposta armazenada para a representação adequada ao tipo da questão.
  #
  # === Argumentos
  #
  # +resposta+:: Respostum contendo o valor persistido.
  # +tipo+:: String que identifica questões +text+, +boolean+ ou numéricas.
  #
  # === Retorno
  #
  # Retorna o texto informado, +Sim+, +Não+ ou a representação textual do número.
  #
  # === Efeitos colaterais
  #
  # Não possui efeitos colaterais.
  def formatar_resposta(resposta, tipo)
    case tipo
    when "boolean"
      case resposta.valor_numerico
      when 1 then "Sim"
      when 0 then "Não"
      else "—"
      end
    when "rating"
      resposta.valor_numerico.nil? ? "—" : "#{resposta.valor_numerico}/5"
    else
      resposta.valor_texto.presence || "—"
    end
  end
end
