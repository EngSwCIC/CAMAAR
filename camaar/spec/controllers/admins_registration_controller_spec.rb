require 'rails_helper'
RSpec.describe Admins::RegistrationsController, type: :controller do
  @controller = Admins::RegistrationsController.new
  before do
    allow(controller).to receive(:authenticate_admin!).and_return(true)
    @request.env['devise.mapping'] = Devise.mappings[:admin]
  end

  it 'creates new admin' do
    admin = build(:admin, :admin2)
    post :create,
         params: { admin: { email: admin.email, password: admin.password,
                            password_confirmation: admin.password_confirmation } }
    expect(response).to have_http_status(:redirect)
    expect(response).to redirect_to(root_path) # Assuming redirection to root_path
    expect(Admin.find_by(email: admin.email)).to_not be_nil
  end

  it 'should redirect to forbidden page when trying to edit' do
    admin = create(:admin, :admin1)
    sign_in admin
    get :edit
    expect(response).to have_http_status(:forbidden)
    admin.destroy
  end

  it 'destroy admin' do
    admin = create(:admin, :admin1)
    sign_in admin
    delete :destroy
    expect(Admin.find_by(email: admin.email)).to be_nil
  end
end
