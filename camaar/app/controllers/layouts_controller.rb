class LayoutsController < ApplicationController
  def index
    @user = User.new
    @user = User.all
  end

end
