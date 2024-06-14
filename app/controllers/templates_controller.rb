# frozen_string_literal: true

# Controls routes for templates.
class TemplatesController < ApplicationController
  include AuthenticationConcern

  def index
    return unless user_authenticated

    @templates = Template.all
  end
end
