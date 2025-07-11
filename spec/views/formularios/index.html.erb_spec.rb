require 'rails_helper'

RSpec.describe "formularios/index", type: :view do
  before(:each) do
    assign(:formularios, [
      Formulario.create!(
        template: nil,
        turma: nil,
        coordenador: nil
      ),
      Formulario.create!(
        template: nil,
        turma: nil,
        coordenador: nil
      )
    ])
  end

  it "renders a list of formularios" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
