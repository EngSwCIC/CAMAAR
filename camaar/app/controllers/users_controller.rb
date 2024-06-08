class UsersController < ApplicationController
  # before_filter :require_user, :only => [:show]

  def index
    @user = User.new
    @user = User.all
  end

  def login
    @user = User.new
    @user = User.all
  end

  private

  def require_user
    @user = User.find_by_id(params[:id])
    redirect_to root_url if @user.nil?
  end

end
