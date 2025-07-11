require 'rails_helper'

RSpec.describe "resposta/show", type: :view do
  before(:each) do
    assign(:respostum, Respostum.create!(
      formulario: nil,
      pergunta: nil,
      opcao: nil,
      resposta_texto: "MyText",
      turma: nil,
      uuid_anonimo: "Uuid Anonimo"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Uuid Anonimo/)
  end
end
