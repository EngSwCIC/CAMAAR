class JsonfilesController < ApplicationController
    def import
        
        file_tmp = params[:file]
        return redirect_to uploader_path, notice: 'Somente aquivos do tipo Json são aceitos' unless file_tmp.content_type == 'application/json'
            
        return redirect_to uploader_path, notice: 'Somente aquivos "class_members.json" ou "classes.json"' unless ((file_tmp.original_filename == "class_members.json") or (file_tmp.original_filename == "classes.json"))
            
            
        if (file_tmp.original_filename == "class_members.json")
            path = "db/json/class_members.json"
        elsif (file_tmp.original_filename == "classes.json")
            path = "db/json/classes.json"
        end

        @file_content = JSON.parse(File.read(file_tmp))
        
        File.open(path, 'w') do |f|
            f.write(JSON.pretty_generate(@file_content))
        end

        redirect_to uploader_path, notice: 'Arquivo importado!'
    end
end
