# require 'rails_helper'
# RSpec.describe Users::RegistrationsController, type: :controller do
#   let(:user) { create(:user, :user1) }
#   @controller = Users::RegistrationsController.new
#   before do
#     allow(controller).to receive(:authenticate_user!).and_return(true)
#     allow(controller).to receive(:current_user).and_return(user)
#     @request.env['devise.mapping'] = Devise.mappings[:user]
#     sign_in user
#   end

#   it 'changes user attributes' do
#     put :update, params: { user: { email: 'jerry@test.com' } }
#     user.reload
#     expect(user.email).to eq 'jerry@test.com'
#   end
# end
