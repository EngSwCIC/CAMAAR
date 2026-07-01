require 'rails_helper'

RSpec.describe Admin::ImportsHelper, type: :helper do
  it "carrega o módulo corretamente" do
    expect(helper).to be_a(Admin::ImportsHelper)
  end
end