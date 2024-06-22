class SessionsController < ApplicationController
    def destroy
        logout current_user
        redirect_to root_path notice: "Tu deslogou"
    end
    
    def create
        user = Usuario.find_by(email: params[:email],senha:params[:senha])
        if user
            login user
            redirect_to avaliacoes_path(alert_message_happy: "Parabéns princeso vc está logado")
            Rails.logger.info("usuario aqui oh: #{current_user[:senha]}")
        else
            Rails.logger.info("Falhou bruxo: #{params[:email]}")
    
            redirect_to root_path(alert_message: "Email ou senha incorretos. Tente novamente")

        end
    end

    def new
        @alert_message = params[:alert_message] if params[:alert_message].present?
        @alert_message_happy = params[:alert_message_happy] if params[:alert_message_happy].present?
    end

end