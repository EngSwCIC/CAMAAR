class ResponseController < ApplicationController
  def show
    @form_request = FormRequest.find(params[:id])
    render layout: "home"
  end
end
