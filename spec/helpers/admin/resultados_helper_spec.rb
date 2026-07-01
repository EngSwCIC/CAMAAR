require 'rails_helper'

RSpec.describe Admin::ResultadosHelper, type: :helper do
  it "carrega o módulo corretamente" do
    expect(helper).to be_a(Admin::ResultadosHelper)
  end
end