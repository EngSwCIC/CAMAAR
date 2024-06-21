class UploaderController < ApplicationController
    def index
        path1 = 'db/json/classes.json'
        if File.file?(path1)
            @json_classes = JSON.parse(File.read(path1))
        end

        path2 = 'db/json/class_members.json'
        if File.file?(path2)
            @json_members = JSON.parse(File.read(path2))
        end
    end
end
