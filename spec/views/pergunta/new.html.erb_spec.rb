require 'rails_helper'

RSpec.describe "pergunta/new", type: :view do
  before(:each) do
    assign(:perguntum, Perguntum.new(
      template: nil,
      titulo: "MyString",
      tipo: 1,
      ordem: 1
    ))
  end

  it "renders new perguntum form" do
    render

    assert_select "form[action=?][method=?]", pergunta_path, "post" do

      assert_select "input[name=?]", "perguntum[template_id]"

      assert_select "input[name=?]", "perguntum[titulo]"

      assert_select "input[name=?]", "perguntum[tipo]"

      assert_select "input[name=?]", "perguntum[ordem]"
    end
  end
end
