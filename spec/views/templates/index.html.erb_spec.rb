# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'templates/index', type: :view do
  let(:current_user) do
    User.create!(name: 'Admin User', email: 'admin@example.com', password: 'password', matricula: '00000',
                 role: 'admin')
  end
  let(:templates) do
    [
      Template.create!(titulo: 'Avaliação de Disciplina', publico_alvo: 'alunos',
                       criado_por: current_user),
      Template.create!(titulo: 'Avaliação de Professor', publico_alvo: 'professores', criado_por: current_user)
    ]
  end

  before do
    assign(:templates, templates)
    allow(view).to receive(:current_user).and_return(current_user)
  end

  it 'renders a list of templates' do
    render
    expect(rendered).to include('Avaliação de Disciplina')
    expect(rendered).to include('Avaliação de Professor')
  end

  it 'shows template target audience' do
    render
    expect(rendered).to include('Alunos')
    expect(rendered).to include('Professores')
  end

  it 'contains links to show each template' do
    render
    templates.each do |template|
      expect(rendered).to include(template_path(template))
    end
  end
end
