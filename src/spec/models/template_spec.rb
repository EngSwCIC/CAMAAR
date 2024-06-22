require 'rails_helper'

RSpec.describe Template, type: :model do
  before(:each) do
    @admin = User.create(email: "admin1@email.com", password: "senh@123", isAdmin: true)
  end

  it "deve criar um template" do
    Template.create(user: @admin)
    expect(Template.count).to equal(1)
  end
end
