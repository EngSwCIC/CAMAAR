require 'rails_helper'
RSpec.describe Users::RegistrationsController, type: :controller do
  @controller = Users::RegistrationsController.new
  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  it 'creates new user' do
    user = build(:user, :user1)
    post :create,
         params: { user: { email: user.email, password: user.password,
                           password_confirmation: user.password_confirmation } }
    expect(response).to have_http_status(:redirect)
    expect(response).to redirect_to(root_path) # Assuming redirection to root_path
    expect(User.find_by(email: user.email)).to_not be_nil
  end
  # it 'changes user attributes' do
  #   put :update, params: { user: { email: 'jerry@test.com' } }
  #   user.reload
  #   expect(user.email).to eq 'jerry@test.com'
  # end
end
