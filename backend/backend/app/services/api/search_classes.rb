##
# Esta classe cuida da efetuação das requisições para o scrapper no endpoint turmas
#
# É retornado as turmas resultantes da busca das turmas no SIGAA
class Api::SearchClasses  < ApplicationController

    def headers
        {
          'Accept': 'application/json',
          'Content-type': 'application/json'
        }
    end

    def self.call
        new.call
    end

    def call
        url = 'http://localhost:3030/turmas'
        request = RestClient.post(url, {}, headers)
        request.body
    end

end