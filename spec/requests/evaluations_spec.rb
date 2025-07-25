# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Evaluations', type: :request do
  let(:user) { FactoryBot.create(:user) }

  before do
    # Simula usuário logado com Devise
    login_as(user, scope: :user)
  end

  describe 'GET /index' do
    it 'returns http success' do
      get '/evaluations'
      expect(response).to have_http_status(:success)
    end
  end
end
