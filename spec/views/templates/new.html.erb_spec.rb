require 'rails_helper'

RSpec.describe "templates/new", type: :view do
  before(:each) do
    assign(:template, Template.new(
      titulo: "MyString",
      publico_alvo: 1,
      criado_por: nil
    ))
  end

  it "renders new template form" do
    render

    assert_select "form[action=?][method=?]", templates_path, "post" do

      assert_select "input[name=?]", "template[titulo]"

      assert_select "input[name=?]", "template[publico_alvo]"

      assert_select "input[name=?]", "template[criado_por_id]"
    end
  end
end
