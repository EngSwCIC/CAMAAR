require 'rails_helper'

RSpec.describe Admin::FormulariosHelper, type: :helper do
  it "carrega o módulo corretamente" do
    expect(helper).to be_a(Admin::FormulariosHelper)
  end
end