require 'rails_helper'

RSpec.describe "resposta/index", type: :view do
  before(:each) do
    assign(:resposta, [
      Respostum.create!(
        formulario: nil,
        pergunta: nil,
        opcao: nil,
        resposta_texto: "MyText",
        turma: nil,
        uuid_anonimo: "Uuid Anonimo"
      ),
      Respostum.create!(
        formulario: nil,
        pergunta: nil,
        opcao: nil,
        resposta_texto: "MyText",
        turma: nil,
        uuid_anonimo: "Uuid Anonimo"
      )
    ])
  end

  it "renders a list of resposta" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Uuid Anonimo".to_s), count: 2
  end
end
