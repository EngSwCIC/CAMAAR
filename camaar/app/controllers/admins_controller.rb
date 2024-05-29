class AdminsController < ApplicationController
  def index
    @admin = Admin.new
    @admin = Admin.all
  end

  def login
    @admin = Admin.new
    @admin = Admin.all
  end

end
