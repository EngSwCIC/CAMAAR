class IndexController < ApplicationController
  include AuthenticationConcern
  def index
    if self.user_authenticated
      redirect_to home_path
    end
  end
end