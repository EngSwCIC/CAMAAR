require 'rails_helper'

RSpec.describe SubjectClassesController, type: :controller do
  let(:user) { create(:user, :user1) }

  describe 'user cant see subject classes' do
    it 'allows to access :index route' do
      get :index
      expect(response).to have_http_status(:forbidden)
    end
  end

  # describe 'admin with no dpto or classes cant see' do
  #   let(:admin) { create(:admin, :admin1) }
  #   before do
  #     allow(controller).to receive(:authenticate_admin!).and_return(true)
  #     allow(controller).to receive(:current_admin).and_return(admin)
  #     @request.env['devise.mapping'] = Devise.mappings[:admin]
  #   end

  #   it 'should not see classes' do # Added `do` here
  #     sign_in admin
  #     get :index
  #     expect(response).to have_http_status(:forbidden)
  #     expect(page).to have_content 'zeca'
  #   end
  # end
end
