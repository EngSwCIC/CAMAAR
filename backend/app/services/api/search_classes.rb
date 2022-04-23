class Api::SearchClasses  < ApplicationController

    def initialize
    end
    
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