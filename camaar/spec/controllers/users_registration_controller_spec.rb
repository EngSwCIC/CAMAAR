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
  it 'should redirect to forbidden page when trying to edit' do
    user = create(:user, :user1)
    sign_in user
    get :edit
    expect(response).to have_http_status(:forbidden)
  end
  it 'destroy user' do
    user = create(:user, :user1)
    sign_in user
    delete :destroy
    expect(User.find_by(email: user.email)).to be_nil
  end
end
