require 'rails_helper'

RSpec.describe "resposta/edit", type: :view do
  let(:respostum) {
    Respostum.create!(
      formulario: nil,
      pergunta: nil,
      opcao: nil,
      resposta_texto: "MyText",
      turma: nil,
      uuid_anonimo: "MyString"
    )
  }

  before(:each) do
    assign(:respostum, respostum)
  end

  it "renders the edit respostum form" do
    render

    assert_select "form[action=?][method=?]", respostum_path(respostum), "post" do

      assert_select "input[name=?]", "respostum[formulario_id]"

      assert_select "input[name=?]", "respostum[pergunta_id]"

      assert_select "input[name=?]", "respostum[opcao_id]"

      assert_select "textarea[name=?]", "respostum[resposta_texto]"

      assert_select "input[name=?]", "respostum[turma_id]"

      assert_select "input[name=?]", "respostum[uuid_anonimo]"
    end
  end
end
