require 'rails_helper'
RSpec.describe Users::ConfirmationsController, type: :controller do
  @controller = Users::ConfirmationsController.new
  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  it 'get confirmations new' do
    get :new

    expect(response).to render_template(:new)
  end

  it 'post confirmations create' do
    user = create(:user, :user1, confirmed_at: nil)
    post :create,
         params: { user: { email: user.email, password: user.password,
                           password_confirmation: user.password_confirmation } }
    expect(response).to have_http_status(:redirect)
  end
end
