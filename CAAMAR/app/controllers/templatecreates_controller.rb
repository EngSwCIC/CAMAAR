class TemplatecreatesController < ApplicationController
    def import

      name = params[:name]

      qs = JSON.parse(params[:stringq])

      path = 'db/json/templates.json'

      json_templates = File.file?(path) ? JSON.parse(File.read(path)) : []
      
      cur_template = {
        "id": json_templates.size,
        "name": name,
        "active": 1,
        "questions": qs
      }

      json_templates = json_templates + [cur_template]

      File.open(path, 'w') do |f|
          f.write(JSON.pretty_generate(json_templates))
      end

      return redirect_to '/gerenciamento'
    end
end
