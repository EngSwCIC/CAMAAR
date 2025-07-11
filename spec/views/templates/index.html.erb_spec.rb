require 'rails_helper'

RSpec.describe "templates/index", type: :view do
  before(:each) do
    assign(:templates, [
      Template.create!(
        titulo: "Titulo",
        publico_alvo: 2,
        criado_por: nil
      ),
      Template.create!(
        titulo: "Titulo",
        publico_alvo: 2,
        criado_por: nil
      )
    ])
  end

  it "renders a list of templates" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Titulo".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
