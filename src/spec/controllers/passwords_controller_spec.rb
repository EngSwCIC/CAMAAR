require 'rails_helper'

RSpec.describe Users::PasswordsController, type: :controller do
  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid email' do
      let(:user) { create(:user) } # assumindo que você tenha FactoryBot configurado

      it 'sends reset password instructions' do
        expect {
          post :create, params: { user: { email: user.email } }
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'redirects to sign in path after sending instructions' do
        post :create, params: { user: { email: user.email } }
        expect(response).to redirect_to(new_session_path(:user))
      end
    end

    context 'with invalid email' do
      it 'renders the new template' do
        post :create, params: { user: { email: 'invalid_email@example.com' } }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    context 'with valid reset token' do
      let(:user) { create(:user, reset_password_token: 'valid_token') }

      it 'renders the edit template' do
        get :edit, params: { reset_password_token: user.reset_password_token }
        expect(response).to render_template :edit
      end
    end

    context 'with invalid reset token' do
      it 'redirects to sign in path' do
        get :edit, params: { reset_password_token: 'invalid_token' }
        expect(response).to redirect_to(new_session_path(:user))
      end
    end
  end

  describe 'PUT #update' do
    let(:user) { create(:user, reset_password_token: 'valid_token', reset_password_sent_at: Time.now) }

    context 'with valid password' do
      it 'resets the password' do
        put :update, params: { user: { reset_password_token: user.reset_password_token, password: 'new_password', password_confirmation: 'new_password' } }
        user.reload
        expect(user.valid_password?('new_password')).to be_truthy
      end

      it 'signs in the user after reset' do
        put :update, params: { user: { reset_password_token: user.reset_password_token, password: 'new_password', password_confirmation: 'new_password' } }
        expect(subject.current_user).to eq(user)
      end

      it 'redirects to root path after reset' do
        put :update, params: { user: { reset_password_token: user.reset_password_token, password: 'new_password', password_confirmation: 'new_password' } }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid password' do
      it 'renders the edit template' do
        put :update, params: { user: { reset_password_token: user.reset_password_token, password: 'new_password', password_confirmation: 'wrong_password' } }
        expect(response).to render_template :edit
      end
    end
  end
end
