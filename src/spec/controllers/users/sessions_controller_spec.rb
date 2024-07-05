require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  before do
    Rails.application.routes.default_url_options[:host] = 'http://localhost:3000'
  end
    context 'with invalid params' do
      it 're-renders the new template' do
        post :create, params: { user: { email: 'invalid_email@example.com', password: 'invalid_password' } }
        expect(response).to render_template :new
      end
    end
  end

end
