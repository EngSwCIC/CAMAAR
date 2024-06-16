require 'rails_helper'
RSpec.describe Admins::RegistrationsController, type: :controller do
  @controller = Admins::RegistrationsController.new
  before do
    allow(controller).to receive(:authenticate_admin!).and_return(true)
    @request.env['devise.mapping'] = Devise.mappings[:admin]
  end

  it 'creates new admin' do
    admin = build(:admin, :admin1)
    post :create,
         params: { admin: { email: admin.email, password: admin.password,
                            password_confirmation: admin.password_confirmation } }
    expect(response).to have_http_status(:redirect)
    expect(response).to redirect_to(root_path) # Assuming redirection to root_path
    expect(Admin.find_by(email: admin.email)).to_not be_nil
  end
  it 'should redirect to forbidden page when trying to edit' do
    departament = create(:department, :departament1)
    admin = create(:admin, :admin1)
    coordinator = create(:coordinator, :coordinator1)
    sign_in admin
    get :edit
    expect(response).to have_http_status(:forbidden)
  end
  # it 'changes admin attributes' do
  #   admin = create(:admin, :admin1)
  #   put :update,
  #       params: { admin: { email: admin.email, password: 'xyz123',
  #                         password_confirmation: 'xyz123' } }
  #   admin.reload
  #   expect(admin.email).to eq admin.email
  # end
end
