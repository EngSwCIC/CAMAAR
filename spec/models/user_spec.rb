require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }

  it "should have a find_pending_forms function" do
    expect(user).to respond_to(:find_pending_forms)
  end

  it "should return forms" do
    frs = FactoryBot.build_list(:form_request, 5)
    frs.each do |fr|
      fr.user = user
      fr.save!
    end
    # form_request.user = user
    # form_request.save!

    expect(user.find_pending_forms).to contain_exactly(*frs)
  end

  it "should return the right forms" do
    fr1 = FactoryBot.build(:form_request)
    fr1.user = user
    fr1.save!

    # Answered
    fr2 = FactoryBot.build(:form_request)
    fr2.answered = true
    fr2.save!

    # Different user
    FactoryBot.create(:form_request)

    expect(user.find_pending_forms).to contain_exactly(fr1)
  end
end
