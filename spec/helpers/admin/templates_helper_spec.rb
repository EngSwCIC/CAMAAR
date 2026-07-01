require 'rails_helper'

RSpec.describe Admin::TemplatesHelper, type: :helper do
  it "carrega o módulo corretamente" do
    expect(helper).to be_a(Admin::TemplatesHelper)
  end
end