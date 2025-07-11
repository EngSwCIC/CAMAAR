require 'rails_helper'

RSpec.describe "matriculas/new", type: :view do
  before(:each) do
    assign(:matricula, Matricula.new(
      user: nil,
      turma: nil
    ))
  end

  it "renders new matricula form" do
    render

    assert_select "form[action=?][method=?]", matriculas_path, "post" do

      assert_select "input[name=?]", "matricula[user_id]"

      assert_select "input[name=?]", "matricula[turma_id]"
    end
  end
end
