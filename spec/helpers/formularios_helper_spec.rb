require 'rails_helper'

RSpec.describe FormulariosHelper, type: :helper do
  it "carrega o módulo corretamente" do
    expect(helper).to be_a(FormulariosHelper)
  end
end
