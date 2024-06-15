require 'rails_helper'
RSpec.describe Users::SessionsController, type: :controller do
  let(:user) { create(:user, :user1) }
  @controller = Users::SessionsController.new
  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  it 'blocks unauthenticated access' do
    admin = create(:admin, :admin1)
    sign_in admin

    get :new

    expect(response).to render_template(:new)
  end

  it 'allows authenticated access' do
    sign_in user

    get :new

    expect(response).to redirect_to(forms_path)
  end

  describe 'DELETE #destroy' do
    before do
      sign_in user
    end

    it 'signs out the user' do
      delete :destroy
      expect(response).to redirect_to(root_path)
    end
  end
end
