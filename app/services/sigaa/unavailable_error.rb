module SIGAA
  class UnavailableError < StandardError
    def flash_message
      "Não foi possível buscar os dados. Tente novamente mais tarde."
    end
  end
end
