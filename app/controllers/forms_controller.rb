class FormsController < ApplicationController
  include ManagerHelper
  include AuthenticationConcern

  def index
    return unless user_authenticated && admin_user?

    @forms = Form.all
  end

  def show
    redirect_to root_path unless user_authenticated && admin_user?

    @form = Form.find(params[:id])
  end

  def create
    Rails.logger.debug("Received: #{params[:questions].inspect}")
  end

  def update
    Rails.logger.debug("Received: #{params[:questions].inspect}")
  end
end
