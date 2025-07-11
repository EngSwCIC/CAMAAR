require 'rails_helper'

RSpec.describe "disciplinas/index", type: :view do
  before(:each) do
    assign(:disciplinas, [
      Disciplina.create!(
        nome: "Nome",
        curso: nil
      ),
      Disciplina.create!(
        nome: "Nome",
        curso: nil
      )
    ])
  end

  it "renders a list of disciplinas" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Nome".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
