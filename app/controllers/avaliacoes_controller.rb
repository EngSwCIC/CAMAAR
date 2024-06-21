class AvaliacoesController < ApplicationController
  before_action :authenticate_user!

  def index
    @forms = current_user.find_pending_forms
    render layout: "home"
  end

  def show
    @form_request = FormRequest.find(params[:id])
    render layout: "home"
  end
end
