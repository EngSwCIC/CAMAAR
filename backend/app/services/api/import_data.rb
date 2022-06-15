##
# Esta classe cuida da efetuação das requisições para o scrapper no endpoint participantes
#
# É retornado os participantes resultantes da extração do SIGAA
class Api::ImportData < ApplicationController

    def self.call(params)
        new.call(params)
    end

    def call(params)
        url = 'http://localhost:3030/participantes'
        resultado = RestClient.post(url, params, :content_type => 'application/json', :accept => 'application/json')
        resultado.body
    end
    
end