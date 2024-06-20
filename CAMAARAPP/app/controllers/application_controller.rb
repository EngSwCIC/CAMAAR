class ApplicationController < ActionController::Base

    

    def after_sign_in_path_for(resource)

        if resource.matricula?
          "http://localhost:3000/tela_alunos"
        else
          "http://localhost:3000/tela_alunos"
        end
      end
      
end
