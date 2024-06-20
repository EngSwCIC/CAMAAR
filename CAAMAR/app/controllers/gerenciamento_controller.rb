class GerenciamentoController < ApplicationController
    def index
        
    end

    def show_templates
        unless helpers.is_user_admin(nil)
            redirect_to "/"
            return
        end
        
        path = 'db/json/templates.json'
        data = File.read(path)
        @templates = JSON.parse(data)
    end
  end
  