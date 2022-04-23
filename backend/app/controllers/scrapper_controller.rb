class ScrapperController < ApplicationController
    
    def headers
        {
          'Accept': 'application/json',
          'Content-type': 'application/json'
        }
    end

    def index
        params = request.body.read
        url = 'http://localhost:3030/turmas'
        request = RestClient.post(url, :param1 => params, :content_type => 'application/json', :accept => 'application/json')
        render json: {
            classes: JSON.parse(request.body)
        }, status: :ok
    end

    #def parse(request)
    #    JSON.parse(request.body)
    #end

    def show
        request = Api::SearchClasses.call
        render json: request, status: :ok
    end
end