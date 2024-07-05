require 'rails_helper'

RSpec.describe Users::ConfirmationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }

    context 'with valid email' do
      it 'sends confirmation instructions' do
        expect {
          post :create, params: { user: { email: user.email } }
        }.to change { ActionMailer::Base.deliveries.count }.by_at_least(1)
      end

      it 'redirects to sign in path after sending instructions' do
        post :create, params: { user: { email: user.email } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'with invalid email' do
      it 'renders the new template' do
        post :create, params: { user: { email: 'invalid_email@example.com' } }
        expect(response).to render_template :new
      end
    end
  end
end
