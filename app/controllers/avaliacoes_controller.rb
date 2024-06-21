class AvaliacoesController < ApplicationController
  before_action :authenticate_user!

  def index
    @forms = FormRequest.all
    render layout: "home"
  end
end
