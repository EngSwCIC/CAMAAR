class SendFormsController < ApplicationController
    def index
        @templates = Template.all
        @study_classes = StudyClass.all
        render layout: "home"
    end
end