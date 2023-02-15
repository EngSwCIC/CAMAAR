require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe Users::SessionsController, type: :controller do
  include FactoryBot::Syntax::Methods

  describe 'POST #create' do
    context 'when the credentials are correct' do
      it 'responds with a JSON object indicating success' do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        user = create(:user)
        post 'auth/sign_in',
             params: { email: user.email,
                       password: user.password }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(
          'message' => 'Autenticado com sucesso',
          'user' => user,
          'authenticated' => true
        )
        expect(response.header['Authorization']).to_not be_nil
      end

      it 'signs the user in' do
        expect(controller.current_user).to eq(user)
      end
    end

    context 'when the credentials are incorrect' do
      before do
        post :create, params: { email: 'invalido', password: 'invalido' }
      end

      it 'responds with a JSON object indicating failure' do
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq(
          'message' => 'Email ou senha invalidos',
          'authenticated' => false
        )
      end

      it 'does not sign the user in' do
        expect(controller.current_user).to be_nil
      end
    end
  end
end
