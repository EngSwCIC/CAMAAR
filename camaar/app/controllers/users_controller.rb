class UsersController < ApplicationController
  def index
    @user = User.new
    @user = User.all
  end

  def login
    @user = User.new
    @user = User.all
  end
end
