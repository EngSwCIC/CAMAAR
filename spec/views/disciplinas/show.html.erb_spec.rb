require 'rails_helper'

RSpec.describe "disciplinas/show", type: :view do
  before(:each) do
    assign(:disciplina, Disciplina.create!(
      nome: "Nome",
      curso: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Nome/)
    expect(rendered).to match(//)
  end
end
