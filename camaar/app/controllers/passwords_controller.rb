class PasswordsController < ApplicationController
    #before_action :require_user_logged_in! <- definir em application_controller

    def create
        user - User.find_by(email: params[:email])
        if @user.present?
            PasswordMailer.with(user: @user).reset.deliver_now
    end

    def edit
        
        #Current.user - User.find_by(id:session[:user_id])
        #Rails.application.routes.url_helpers.edit_user_password_path(reset_password_token: user.send (:set_reset_password_token))
    end

    def update
        if Current.user.update(password_params)
            redirect_to root_path, notice "Senha Atualizada!"
        end
    end

    private 
    def password_params
        params.require(:user).permit(:password, :password_confirmation)
    end

end