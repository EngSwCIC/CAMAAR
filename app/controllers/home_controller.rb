class HomeController < ApplicationController
  include AuthenticationConcern
  def index
    if self.authenticate_user == true
      render 'home'
    else
      redirect_to root_path, alert: "Acesso não autorizado"
    end
  end
end