require 'rails_helper'
RSpec.describe SubjectClassesController, type: :controller do
  let(:admin) { create(:admin, :admin1) }
  @controller = SubjectClassesController.new
  before do
    allow(controller).to receive(:authenticate_admin!).and_return(true)
    allow(controller).to receive(:current_admin).and_return(admin)
    @request.env['devise.mapping'] = Devise.mappings[:admin]
  end

  it 'allows to access :index route' do
    get :index
    expect(response).to have_http_status(:forbidden)
  end
end
