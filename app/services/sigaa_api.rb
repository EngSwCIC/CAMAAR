class SigaaApi
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

  def self.scenario
    ENV["SIGAA_SCENARIO"]&.to_sym || :success
  end
end