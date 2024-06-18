# frozen_string_literal: true

# Controls routes for templates.
class TemplatesController < ApplicationController
  include AuthenticationConcern

  def index
    return unless user_authenticated

    @templates = Template.all
  end

  def show
    @template = Template.find(params[:id])

    respond_to do |format|
      format.html
      format.csv {send_data @template.to_csv}
    end
    
  end 
end
