class TemplatesController < ApplicationController
    def index
        @questions = Question.all
    end
end