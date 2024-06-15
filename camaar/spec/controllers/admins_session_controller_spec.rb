require 'rails_helper'
RSpec.describe Admins::SessionsController, type: :controller do
  let(:admin) { create(:admin, :admin1) }
  @controller = Admins::SessionsController.new
  before do
    allow(controller).to receive(:authenticate_admin!).and_return(true)
    allow(controller).to receive(:current_admin).and_return(admin)
    @request.env['devise.mapping'] = Devise.mappings[:admin]
  end

  it 'blocks unauthenticated access' do
    user = create(:user, :user1)
    sign_in user

    get :new

    expect(response).to render_template(:new)
  end

  it 'allows authenticated access' do
    sign_in admin

    get :new

    expect(response).to redirect_to(templates_path)
  end

  describe 'DELETE #destroy' do
    before do
      sign_in admin
    end

    it 'signs out the admin' do
      delete :destroy
      expect(response).to redirect_to(root_path)
    end
  end
end
