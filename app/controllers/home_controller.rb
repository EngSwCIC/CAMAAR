class HomeController < ApplicationController
  include AuthenticationConcern
  def index
    self.authenticate_user
    render 'home'
  end
end
