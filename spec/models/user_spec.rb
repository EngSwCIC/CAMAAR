require 'rails_helper'

RSpec.describe User, type: :model do
  it "should have a find_pending_forms function" do
    @user = FactoryBot.create(:user)
    expect(@user).to respond_to(:find_pending_forms)
  end
end
