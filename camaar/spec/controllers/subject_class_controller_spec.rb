require 'rails_helper'

RSpec.describe SubjectClassesController, type: :controller do
  let(:user) { create(:user, :user1) }

  describe 'user cant see subject classes' do
    it 'allows to access :index route' do
      get :index
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'admin that is not a coordinator cannot access' do
    let(:admin) { create(:admin, :admin1) }
    before do
      allow(controller).to receive(:authenticate_admin!).and_return(true)
      allow(controller).to receive(:current_admin).and_return(admin)
      @request.env['devise.mapping'] = Devise.mappings[:admin]
    end

    it 'should not see classes' do # Added `do` here
      sign_in admin
      get :index
      expect(response).to have_http_status(:forbidden)
    end

    it 'should get index' do
      departament = create(:department, :departament1)
      coordinator = create(:coordinator, :coordinator1)
      user = create(:user, :user5)
      teacher = create(:teacher, :teacher1)
      classes = create(:subject_class, :subject_class1)
      sign_in admin
      get :index
      expect(response).to have_http_status(:ok)
    end
  end
end
