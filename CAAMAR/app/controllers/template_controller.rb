class TemplateController < ApplicationController
    def index

    end

    def delete_template
      path = 'db/json/templates.json'
      data = File.read(path)
      templates = JSON.parse(data)
      templates[params[:template][:delId].to_i]["active"] = 0
      File.open(path, 'w') do |f|
        f.write(JSON.pretty_generate(templates))
      end

      redirect_to request.original_url
    end

    def edit_template

      path = 'db/json/templates.json'
      data = File.read(path)
      templates = JSON.parse(data)
      
      @temp = templates[params[:id].to_i]
    end

    def edit
      
      path = 'db/json/templates.json'
      data = File.read(path)
      templates = JSON.parse(data)

      novo_t = {}
      novo_t['id'] = params[:passa][:id].to_i
      novo_t['name'] = params[:passa][:name]
      novo_t['active'] = 1
      novo_t['questions'] = JSON.parse(params[:passa][:stringq])
    
      templates[params[:passa][:id].to_i] = novo_t
      File.open(path, 'w') do |f|
        f.write(JSON.pretty_generate(templates))
      end

      redirect_to "/gerenciamento"
    end
  end
  