require 'rails_helper'

describe Users::ConfirmationsController do
    before(:each) do
      request.env['devise.mapping'] = Devise.mappings[:user]
      cria_usuario
    end

    context "Controladora de Confirmação" do
        it "GET #new retorna código de http 200" do
            get :new
            expect(response).to have_http_status(200)
        end

        it "POST #create com email certo" do
            post :create, params: {
                user: {email: @user.email}, 
                commit: "Reenvie instruções de Confirmação",
            }
            expect(response).to have_http_status(303)
            expect(response).to redirect_to(new_user_session_path)
        end

        it "POST #create com email não cadastrado" do
            post :create, params: {
                user: {email: "email@nãocadastrado.com"}, 
                commit: "Reenvie instruções de Confirmação",
            }
            expect(response).to have_http_status(422)
        end
    end
end