require 'rails_helper'

RSpec.describe Devise::SessionsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  let(:user) { create(:user, email: 'test@example.com', password: 'password123') }

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end

    it 'assigns a new user for sign in' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST #create' do
    context 'with valid credentials (Happy Path)' do
      it 'authenticates user successfully' do
        post :create, params: { user: { email: user.email, password: 'password123' } }
        expect(controller.current_user).to eq(user)
      end

      it 'redirects to root path after successful login' do
        post :create, params: { user: { email: user.email, password: 'password123' } }
        expect(response).to redirect_to(root_path)
      end

      it 'sets success notice' do
        post :create, params: { user: { email: user.email, password: 'password123' } }
        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid credentials (Sad Path)' do
      it 'handles invalid email' do
        post :create, params: { user: { email: 'wrong@example.com', password: 'password123' } }
        expect(controller.current_user).to be_nil
        expect(response).to render_template(:new)
      end

      it 'handles invalid password' do
        post :create, params: { user: { email: user.email, password: 'wrongpassword' } }
        expect(controller.current_user).to be_nil
        expect(response).to render_template(:new)
      end

      it 'shows error message for invalid credentials' do
        post :create, params: { user: { email: user.email, password: 'wrongpassword' } }
        expect(flash[:alert]).to be_present
      end
    end

    context 'with missing parameters (Sad Path)' do
      it 'handles missing email' do
        post :create, params: { user: { password: 'password123' } }
        expect(controller.current_user).to be_nil
        expect(response).to render_template(:new)
      end

      it 'handles missing password' do
        post :create, params: { user: { email: user.email } }
        expect(controller.current_user).to be_nil
        expect(response).to render_template(:new)
      end

      it 'handles completely missing user params' do
        post :create, params: {}
        expect(controller.current_user).to be_nil
        expect(response).to render_template(:new)
      end
    end

    context 'with inactive user (Sad Path)' do
      let(:inactive_user) { create(:user, email: 'inactive@example.com', password: 'password123', ativo: false) }

      it 'rejects inactive user login' do
        post :create, params: { user: { email: inactive_user.email, password: 'password123' } }
        expect(controller.current_user).to be_nil
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is signed in (Happy Path)' do
      before do
        sign_in user
      end

      it 'signs out user successfully' do
        delete :destroy
        expect(controller.current_user).to be_nil
      end

      it 'redirects to root path after logout' do
        delete :destroy
        expect(response).to redirect_to(root_path)
      end

      it 'sets success notice for logout' do
        delete :destroy
        expect(flash[:notice]).to be_present
      end
    end

    context 'when user is not signed in (Sad Path)' do
      it 'handles logout attempt when not signed in' do
        delete :destroy
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # Additional edge case tests
  describe 'edge cases' do
    context 'with malformed parameters' do
      it 'handles malformed email' do
        post :create, params: { user: { email: 'not-an-email', password: 'password123' } }
        expect(controller.current_user).to be_nil
        expect(response).to render_template(:new)
      end

      it 'handles empty email' do
        post :create, params: { user: { email: '', password: 'password123' } }
        expect(controller.current_user).to be_nil
        expect(response).to render_template(:new)
      end

      it 'handles empty password' do
        post :create, params: { user: { email: user.email, password: '' } }
        expect(controller.current_user).to be_nil
        expect(response).to render_template(:new)
      end
    end
  end
end
