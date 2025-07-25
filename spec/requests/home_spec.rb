# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe 'GET /index' do
    context 'when user is logged in' do
      before { login_as(user, scope: :user) }

      it 'returns http success' do
        get '/home/index'
        expect(response).to have_http_status(:success)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login', skip: 'Authentication disabled in test environment' do
        get '/home/index'
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
