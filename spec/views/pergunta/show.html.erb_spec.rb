require 'rails_helper'

RSpec.describe "pergunta/show", type: :view do
  before(:each) do
    assign(:perguntum, Perguntum.create!(
      template: nil,
      titulo: "Titulo",
      tipo: 2,
      ordem: 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Titulo/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
