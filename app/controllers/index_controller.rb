class IndexController < ApplicationController
  include AuthenticationConcern
  def index
    if self.authenticate_user == true
      redirect_to home_path
    else
      redirect_to login_path, alert: "Acesso não autorizado"
    end
  end  
end
