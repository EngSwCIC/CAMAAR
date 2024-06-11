class IndexController < ApplicationController
  def index
    if AuthenticationController.new.check_authentication
      redirect_to home_path
    else
      redirect_to login_path
    end
  end
end