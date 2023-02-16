# A classe ApplicationService é responsável por abstrair o comportamento de executar um funcionalidade por meio da função +call+

class ApplicationService

    # Método utilzado para executar uma determinada funcionalidade
    #
    # ==== Attributes
    #
    # * +params+ - +Hash+ de parametros necessários para executar a funcionalidade desejada
    #
  def self.call(params = {})
    new().call(params)
  end

end
