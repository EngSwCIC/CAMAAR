class TurmasController < ApplicationController
  def index
    unless helpers.is_user_admin(nil)
        redirect_to "/"
        return
    end
    
    path = 'db/json/classes.json'
    if File.file?(path)
      @json_classes = JSON.parse(File.read(path))
    end

    path2 = 'db/json/templates.json'
    if File.file?(path2)
      @json_templates = JSON.parse(File.read(path2))
    end
  end
end
