require 'rails_helper'

describe Users::PasswordsController do

    before(:each) do
      request.env['devise.mapping'] = Devise.mappings[:user]
      cria_usuario
    end

    context "PUT #update" do
      before(:each) do
        @token = @user.send_reset_password_instructions
      end
      
      it "tenta atualizar a senha diferente" do
        put :update, params: {
          user: {
            reset_password_token: @token,
            password: "senhacerta",
            password_confirmation: "senhadiferente"
          },
          commit: "Definir senha"
        }
        expect(response).to have_http_status(422)
      end
      
      describe "atualiza com a senha certa" do
        before(:each) do
          put :update, params: {
          user: {
            reset_password_token: @token,
            password: "senhacerta",
            password_confirmation: "senhacerta"
          },
          commit: "Definir senha"
          }
        end
        
        it "verifica status http" do
          expect(response).to have_http_status(303)
        end

        it "verifica se confirmou o usuário que não estava confirmado" do
          if !@user.confirmed?
            user_refresh
            expect(@user.confirmed?).to be true
          end
        end

        it "verifica se o token foi devidamente excluído" do
          user_refresh
          expect(@user.reset_password_token?).to be false
        end

        it "GET #edit com token expirado" do
          get :edit, params: {reset_password_token: @token}
          expect(flash[:notice]).to be_present
        end
      end
    end
  end