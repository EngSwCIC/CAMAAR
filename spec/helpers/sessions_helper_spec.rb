require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  it "carrega o módulo corretamente" do
    expect(helper).to be_a(SessionsHelper)
  end
end