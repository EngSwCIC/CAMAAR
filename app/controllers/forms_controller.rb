class FormsController < ApplicationController
  include ManagerHelper
  include AuthenticationConcern

  def show
    return unless user_authenticated && admin_user? # TODO: || is student with access (belong to form discipline)

    @form = Form.find(params[:id])
  end

  def create
    Rails.logger.debug("Received: #{params[:questions].inspect}")
  end

  def update
    Rails.logger.debug("Received: #{params[:questions].inspect}")
  end
end
