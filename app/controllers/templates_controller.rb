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
  end
end
