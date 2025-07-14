# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'disciplinas/show', type: :view do
  let(:current_user) do
    User.create!(name: 'Admin User', email: 'admin@example.com', password: 'password', matricula: '00000',
                 role: 'admin')
  end
  let(:curso) { Curso.create!(nome: 'Engenharia de Software') }
  let(:disciplina) { Disciplina.create!(nome: 'Programação Web', curso: curso) }

  before do
    assign(:disciplina, disciplina)
    allow(view).to receive(:current_user).and_return(current_user)
  end

  it 'renders the disciplina nome' do
    render
    expect(rendered).to include('Programação Web')
  end

  it 'renders the curso name' do
    render
    expect(rendered).to include('Engenharia de Software')
  end

  it 'contains edit link' do
    render
    expect(rendered).to include('Edit this disciplina')
  end

  it 'contains back link' do
    render
    expect(rendered).to include('Back to disciplinas')
  end
end
