require 'rails_helper'

RSpec.describe "turmas/new", type: :view do
  before(:each) do
    assign(:turma, Turma.new(
      disciplina: nil,
      professor: nil,
      semestre: "MyString"
    ))
  end

  it "renders new turma form" do
    render

    assert_select "form[action=?][method=?]", turmas_path, "post" do

      assert_select "input[name=?]", "turma[disciplina_id]"

      assert_select "input[name=?]", "turma[professor_id]"

      assert_select "input[name=?]", "turma[semestre]"
    end
  end
end
