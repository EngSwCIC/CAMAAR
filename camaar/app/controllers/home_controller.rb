class HomeController < ApplicationController
  def index
    @user = User.new
    @user = User.all
  end

  def login
    redirect_to 'users/register'
  end

end
