class FormulariosController < ApplicationController
    def index
        @formularios = Formulario.all
    end
end
