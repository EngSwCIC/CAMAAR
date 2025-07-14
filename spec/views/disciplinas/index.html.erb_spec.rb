# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'disciplinas/index', type: :view do
  let(:curso) { Curso.create!(nome: 'Test Course') }
  let(:disciplinas) do
    [
      Disciplina.create!(nome: 'Algoritmos', curso: curso),
      Disciplina.create!(nome: 'Estrutura de Dados', curso: curso)
    ]
  end

  before do
    assign(:disciplinas, disciplinas)
  end

  it 'renders a list of disciplinas' do
    render
    expect(rendered).to include('Algoritmos')
    expect(rendered).to include('Estrutura de Dados')
  end

  it 'contains links to edit each disciplina' do
    render
    disciplinas.each do |disciplina|
      expect(rendered).to include(edit_disciplina_path(disciplina))
    end
  end
end
