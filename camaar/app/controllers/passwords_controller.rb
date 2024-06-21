class PasswordsController < ApplicationController
    # before_action :require_user_logged_in! <- definir em application_controller

    def edit
        Devise.token_generator.generate(User, :reset_password_token)
        Rails.application.routes.url_helpers.edit_user_password_path(reset_password_token: user.send (:set_reset_password_token))
    end

    def update
        if Current.user.update(password_params)
        end
    end

    def password_params
        params.require(:user).permit(:password, :password_confirmation)
    end

end