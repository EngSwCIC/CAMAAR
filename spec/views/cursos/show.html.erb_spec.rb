# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'cursos/show', type: :view do
  let(:curso) { Curso.create!(nome: 'Engenharia de Software') }

  before do
    assign(:curso, curso)
  end

  it 'renders the curso name' do
    render
    expect(rendered).to include('Engenharia de Software')
  end

  it 'contains link to edit' do
    render
    expect(rendered).to include(edit_curso_path(curso))
  end

  it 'contains link to index' do
    render
    expect(rendered).to include(cursos_path)
  end
end
