# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'cursos/index', type: :view do
  let(:cursos) do
    [
      Curso.create!(nome: 'Engenharia de Software'),
      Curso.create!(nome: 'Ciência da Computação')
    ]
  end

  before do
    assign(:cursos, cursos)
  end

  it 'renders a list of cursos' do
    render
    expect(rendered).to include('Engenharia de Software')
    expect(rendered).to include('Ciência da Computação')
  end

  it 'contains links to show each curso' do
    render
    cursos.each do |curso|
      expect(rendered).to include(curso_path(curso))
    end
  end
end
