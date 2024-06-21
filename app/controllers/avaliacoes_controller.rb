class AvaliacoesController < ApplicationController
  def index
    @forms = FormRequest.all
    render layout: "home"
  end
end
