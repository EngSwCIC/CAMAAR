class ApplicationController < ActionController::Base
    def after_sign_in_path_for(resource)

        if resource.adm == "false"
          "http://localhost:3000/user_home"
        else
          "http://localhost:3000/gerenciamento"
        end
      end
      
end
