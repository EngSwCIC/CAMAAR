require 'rails_helper'
RSpec.describe Admins::ConfirmationsController, type: :controller do
  @controller = Admins::ConfirmationsController.new
  before do
    allow(controller).to receive(:authenticate_admin!).and_return(true)
    @request.env['devise.mapping'] = Devise.mappings[:admin]
  end

  it 'get confirmations new' do
    get :new

    expect(response).to render_template(:new)
  end

  it 'post confirmations create' do
    admin = create(:admin, :admin1, confirmed_at: nil)
    post :create,
         params: { admin: { email: admin.email, password: admin.password,
                            password_confirmation: admin.password_confirmation } }
    expect(response).to have_http_status(:redirect)
  end
end
