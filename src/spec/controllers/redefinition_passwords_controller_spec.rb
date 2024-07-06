require 'rails_helper'

describe Users::PasswordsController do
    before(:each) do
        request.env['devise.mapping'] = Devise.mappings[:user]
        cria_usuario
    end

    it "GET #edit com token certo" do
        @token = @user.send_reset_password_instructions
        get :edit, params: {reset_password_token: @token}
        expect(User.with_reset_password_token(@token)).to eq(@user)
        expect(response).to have_http_status(200)
    end

    it "GET #edit com token nulo" do
        get :edit, params: {}
        expect(flash[:notice]).to be_present
    end

end