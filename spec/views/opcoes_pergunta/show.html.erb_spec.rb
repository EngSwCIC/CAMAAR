require 'rails_helper'

RSpec.describe "opcoes_pergunta/show", type: :view do
  before(:each) do
    assign(:opcoes_perguntum, OpcoesPerguntum.create!(
      pergunta: nil,
      texto: "Texto"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Texto/)
  end
end
