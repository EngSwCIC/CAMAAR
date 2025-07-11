require 'rails_helper'

RSpec.describe "pergunta/index", type: :view do
  before(:each) do
    assign(:pergunta, [
      Perguntum.create!(
        template: nil,
        titulo: "Titulo",
        tipo: 2,
        ordem: 3
      ),
      Perguntum.create!(
        template: nil,
        titulo: "Titulo",
        tipo: 2,
        ordem: 3
      )
    ])
  end

  it "renders a list of pergunta" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Titulo".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
  end
end
