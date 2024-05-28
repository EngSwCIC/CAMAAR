class UsersController < ApplicationController
  def index
    @user = User.new
    @user = User.all
  end

  def page
    redirect_to '/users/page'
  end

end
