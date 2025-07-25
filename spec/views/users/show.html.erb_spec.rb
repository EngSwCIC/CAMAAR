# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  let(:current_user) do
    User.create!(name: 'Admin User', email: 'admin@example.com', password: 'password', matricula: '00000',
                 role: 'admin')
  end
  let(:user) do
    User.create!(name: 'João Silva', email: 'joao@example.com', password: 'password', matricula: '12345',
                 role: 'professor')
  end

  before do
    assign(:user, user)
    allow(view).to receive(:current_user).and_return(current_user)
  end

  it 'renders the user name' do
    render
    expect(rendered).to include('João Silva')
  end

  it 'renders the user email' do
    render
    expect(rendered).to include('joao@example.com')
  end

  it 'renders the user matricula' do
    render
    expect(rendered).to include('12345')
  end

  it 'renders the user role' do
    render
    expect(rendered).to include('professor')
  end

  it 'contains edit link for admin users' do
    render
    expect(rendered).to include('Edit this user')
  end

  it 'contains back link' do
    render
    expect(rendered).to include('Back to users')
  end
end
