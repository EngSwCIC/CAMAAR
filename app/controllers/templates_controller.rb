# frozen_string_literal: true

# Controls routes for templates.
class TemplatesController < ApplicationController
  include AuthenticationConcern

  def index
    return unless user_authenticated

    @templates = Template.all

    respond_to do |format|
      format.html
      format.csv {send_data @templates.to_csv}
    end
  end

  def show
    @template = Template.find(params[:id])
  end 
end
