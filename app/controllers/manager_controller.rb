class ManagerController < ApplicationController
    include ManagerHelper 
    include AuthenticationConcern   
    def index
      if authenticate_user == true && admin_user? == true
        render 'index'
      else
        redirect_to root_path, alert: "Acesso não autorizado"
      end
    end
end
