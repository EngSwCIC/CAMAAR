require 'rails_helper'

RSpec.describe PasswordsHelper, type: :helper do
  it "carrega o módulo corretamente" do
    expect(helper).to be_a(PasswordsHelper)
  end
end