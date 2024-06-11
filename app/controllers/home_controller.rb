class HomeController < ApplicationController
  include AuthenticationConcern
  def index
    if self.authenticate_user == true
      render 'home'
    end
  end
end