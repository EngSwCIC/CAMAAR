require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  let(:user) { create(:user, email: 'test@example.com', password: 'password123') }

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end

    it 'renders without layout' do
      get :new
      expect(response).to render_template(layout: false)
    end
  end

  describe 'POST #create' do
    context 'with valid credentials' do
      it 'handles authentication attempt' do
        post :create, params: { user: { email: user.email, password: 'password123' } }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid credentials' do
      it 'handles invalid email' do
        post :create, params: { user: { email: 'wrong@example.com', password: 'password123' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'handles invalid password' do
        post :create, params: { user: { email: user.email, password: 'wrongpassword' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with missing parameters' do
      it 'handles missing email' do
        post :create, params: { user: { password: 'password123' } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq('Por favor, preencha email e senha.')
      end

      it 'handles missing password' do
        post :create, params: { user: { email: user.email } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq('Por favor, preencha email e senha.')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'handles logout' do
      sign_in user
      delete :destroy
      expect(response).to redirect_to(root_path)
    end
  end
end
