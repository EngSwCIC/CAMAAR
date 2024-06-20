class UploaderController < ApplicationController
    def index
        path1 = 'db/json/classes.json'
        @json_classes = JSON.parse(File.read(path1))

        path2 = 'db/json/class_members.json'
        @json_members = JSON.parse(File.read(path2))
    end
end
