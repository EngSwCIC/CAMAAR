class ResultadosController < ApplicationController
  def index
    @forms = FormResponse.all
    render layout: "home"
  end
end
