require 'rails_helper'

describe Users::PasswordsController do

    before(:each) do
      request.env['devise.mapping'] = Devise.mappings[:user]
      cria_usuario
    end
    
    it "GET #new da tela de redefinição de senha retorna código de http 200" do
        get :new
        expect(response).to have_http_status(200)
    end

    it "POST #create com email certo" do
        post :create, params: {
            user: {email: @user.email}, 
            commit: "Reenvie instruções de Confirmação",
        }
        expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it "POST #create com email não cadastrado" do
        post :create, params: {
            user: {email: "email@nãocadastrado.com"}, 
            commit: "Reenvie instruções de Confirmação",
        }
        expect(ActionMailer::Base.deliveries.count).to eq(0)
    end
end