require 'rails_helper'

RSpec.describe "turmas/show", type: :view do
  before(:each) do
    assign(:turma, Turma.create!(
      disciplina: nil,
      professor: nil,
      semestre: "Semestre"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Semestre/)
  end
end
