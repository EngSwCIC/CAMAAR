class EvaluationsController < ApplicationController
    include AuthenticationConcern
    def index
      if self.user_authenticated
        @disciplines_info = Discipline.all_disciplines_info
        render 'index'
      else
        redirect_to root_path, alert: "Acesso não autorizado"
      end
    end
end
