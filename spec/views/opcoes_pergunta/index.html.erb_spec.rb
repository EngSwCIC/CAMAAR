require 'rails_helper'

RSpec.describe "opcoes_pergunta/index", type: :view do
  before(:each) do
    assign(:opcoes_pergunta, [
      OpcoesPerguntum.create!(
        pergunta: nil,
        texto: "Texto"
      ),
      OpcoesPerguntum.create!(
        pergunta: nil,
        texto: "Texto"
      )
    ])
  end

  it "renders a list of opcoes_pergunta" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Texto".to_s), count: 2
  end
end
