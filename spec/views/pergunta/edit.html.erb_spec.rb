require 'rails_helper'

RSpec.describe "pergunta/edit", type: :view do
  let(:perguntum) {
    Perguntum.create!(
      template: nil,
      titulo: "MyString",
      tipo: 1,
      ordem: 1
    )
  }

  before(:each) do
    assign(:perguntum, perguntum)
  end

  it "renders the edit perguntum form" do
    render

    assert_select "form[action=?][method=?]", perguntum_path(perguntum), "post" do

      assert_select "input[name=?]", "perguntum[template_id]"

      assert_select "input[name=?]", "perguntum[titulo]"

      assert_select "input[name=?]", "perguntum[tipo]"

      assert_select "input[name=?]", "perguntum[ordem]"
    end
  end
end
