class UsersController < ApplicationController
  # before_action :authenticate_user!
  # before_action :set_user_data

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
