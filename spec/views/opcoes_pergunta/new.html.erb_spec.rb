require 'rails_helper'

RSpec.describe "opcoes_pergunta/new", type: :view do
  before(:each) do
    assign(:opcoes_perguntum, OpcoesPerguntum.new(
      pergunta: nil,
      texto: "MyString"
    ))
  end

  it "renders new opcoes_perguntum form" do
    render

    assert_select "form[action=?][method=?]", opcoes_pergunta_path, "post" do

      assert_select "input[name=?]", "opcoes_perguntum[pergunta_id]"

      assert_select "input[name=?]", "opcoes_perguntum[texto]"
    end
  end
end
