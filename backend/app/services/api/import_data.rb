class Api::ImportData < ApplicationController

    def initialize
    end

    def self.call(params)
        new.call(params)
    end

    def call(params)
        url = 'http://localhost:3030/participantes'
        resultado = RestClient.post(url, params, :content_type => 'application/json', :accept => 'application/json')
        resultado.body
    end
    
end