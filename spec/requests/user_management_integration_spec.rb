require 'rails_helper'

RSpec.describe 'User Management System', type: :request do
  let(:admin) { create(:user, :admin) }

  describe 'Basic functionality' do
    it 'creates a user' do
      user = create(:user, :aluno)
      expect(user).to be_persisted
      expect(user.role).to eq('aluno')
    end

    it 'validates user model' do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end
  end

  describe 'Discipline management (when logged in as admin)' do
    before do
      sign_in admin
    end

    it 'allows admin to access users index' do
      get users_path
      expect(response).to have_http_status(:success)
    end
  end
end
