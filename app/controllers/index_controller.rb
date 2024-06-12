class IndexController < ApplicationController
  include AuthenticationConcern
  def index
    if authenticate_user == true
      redirect_to home_path
    end
  end  
end