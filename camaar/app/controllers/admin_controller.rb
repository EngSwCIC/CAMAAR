class AdminController < ApplicationController
  def index
    @user = User.new
    @user = User.all
  end

  # def page
  #   redirect_to 'admin#page'
  # end

end
