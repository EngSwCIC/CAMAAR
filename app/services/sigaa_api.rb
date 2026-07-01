# API Simulada (Mock) para comunicação com o SIGAA.
class SigaaApi
  # Busca os dados baseados no cenário de teste configurado.
  #
  # Argumentos: Nenhum
  # Retorno: JSON String
  # Efeitos Colaterais: Lê arquivo local ou lança exceção.
  def self.fetch_data
    case scenario
    when :success
      File.read(Rails.root.join("spec/fixtures/sigaa.json"))

    when :empty
      "[]"

    when :invalid
      raise "Dados inválidos retornados pelo SIGAA"

    when :connection_error
      raise "Falha de conexão com o SIGAA"

    else
      File.read(Rails.root.join("spec/fixtures/sigaa.json"))
    end
  end

  # Recupera o cenário atual do ambiente.
  #
  # Argumentos: Nenhum
  # Retorno: Symbol
  # Efeitos Colaterais: Acessa ENV
  def self.scenario
    ENV["SIGAA_SCENARIO"]&.to_sym || :success
  end
end