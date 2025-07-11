require 'rails_helper'

RSpec.describe "formularios/new", type: :view do
  before(:each) do
    assign(:formulario, Formulario.new(
      template: nil,
      turma: nil,
      coordenador: nil
    ))
  end

  it "renders new formulario form" do
    render

    assert_select "form[action=?][method=?]", formularios_path, "post" do

      assert_select "input[name=?]", "formulario[template_id]"

      assert_select "input[name=?]", "formulario[turma_id]"

      assert_select "input[name=?]", "formulario[coordenador_id]"
    end
  end
end
