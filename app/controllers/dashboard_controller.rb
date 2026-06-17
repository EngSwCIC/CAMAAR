class DashboardController < ApplicationController
  def index
    @workspace = workspace
    @current_user = session[:current_user]
  end
end
