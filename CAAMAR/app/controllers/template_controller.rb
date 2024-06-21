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
  end
  