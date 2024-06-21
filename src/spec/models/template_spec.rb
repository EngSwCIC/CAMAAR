require 'rails_helper'

RSpec.describe Template, type: :model do
  it "deve criar um template" do
    Template.create()
    expect(Template.count).to equal(1)
  end
end
