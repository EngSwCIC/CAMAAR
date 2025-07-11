require 'rails_helper'

RSpec.describe "templates/show", type: :view do
  before(:each) do
    assign(:template, Template.create!(
      titulo: "Titulo",
      publico_alvo: 2,
      criado_por: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Titulo/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(//)
  end
end
