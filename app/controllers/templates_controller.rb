# frozen_string_literal: true

# Controls routes for templates. Only administrators may see or edit templates.
class TemplatesController < ApplicationController
  include ManagerHelper
  include AuthenticationConcern

  # TODO: add authentication with `return unless user_authenticated && admin_user?`

  def index
    @templates = Template.all
  end

  def show
    @template = Template.find(params[:id])
  end

  def create
    Rails.logger.debug("Received: #{params[:questions].inspect}")
  end

  def update
    Rails.logger.debug("Received: #{params[:questions].inspect}")
  end
end
