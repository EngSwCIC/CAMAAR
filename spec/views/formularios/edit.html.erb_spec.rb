require 'rails_helper'

RSpec.describe "formularios/edit", type: :view do
  let(:formulario) {
    Formulario.create!(
      template: nil,
      turma: nil,
      coordenador: nil
    )
  }

  before(:each) do
    assign(:formulario, formulario)
  end

  it "renders the edit formulario form" do
    render

    assert_select "form[action=?][method=?]", formulario_path(formulario), "post" do

      assert_select "input[name=?]", "formulario[template_id]"

      assert_select "input[name=?]", "formulario[turma_id]"

      assert_select "input[name=?]", "formulario[coordenador_id]"
    end
  end
end
