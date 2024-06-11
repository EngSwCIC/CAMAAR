class HomeController < ApplicationController
    def index
      unless AuthenticationController.new.check_authentication
        flash[:error] = "Usuário não autenticado"
        redirect_to '/login' # Redireciona para a página de login se o usuário não estiver autenticado
        return
      end
      render 'home'
    end
end  