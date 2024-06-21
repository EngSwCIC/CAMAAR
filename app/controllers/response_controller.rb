class ResponseController < ApplicationController
  def show
    # @form = User.find(params[:id])
    render layout: "home"
  end
end
