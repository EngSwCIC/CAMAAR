class HomeController < ApplicationController
  include AuthenticationConcern
  def index
    if self.user_authenticated
      render 'home'
    end
  end
end