class LayoutsController < ApplicationController
  def index
    @user = User.new
    @user = User.all
  end

  def page
    redirect_to 'user/page'
  end

end
