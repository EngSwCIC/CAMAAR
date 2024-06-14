# frozen_string_literal: true

# Controls routes for templates.
class TemplatesController < ApplicationController
  include AuthenticationConcern

  def index
    return unless user_authenticated

    @templates = Template.all
  end

  def show
    id = params[:id]
    @template = Template.find(id)
  end
end
