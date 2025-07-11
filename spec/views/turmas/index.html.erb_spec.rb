require 'rails_helper'

RSpec.describe "turmas/index", type: :view do
  before(:each) do
    assign(:turmas, [
      Turma.create!(
        disciplina: nil,
        professor: nil,
        semestre: "Semestre"
      ),
      Turma.create!(
        disciplina: nil,
        professor: nil,
        semestre: "Semestre"
      )
    ])
  end

  it "renders a list of turmas" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Semestre".to_s), count: 2
  end
end
