# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'cursos/index', type: :view do
  before do
    assign(:cursos, [
             Curso.create!(
               nome: 'Nome'
             ),
             Curso.create!(
               nome: 'Nome'
             )
           ])
  end

  it 'renders a list of cursos' do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new('Nome'), count: 2
  end
end
