require 'rails_helper'

RSpec.describe Admin::GerenciamentoHelper, type: :helper do
  it "carrega o módulo corretamente" do
    expect(helper).to be_a(Admin::GerenciamentoHelper)
  end
end