# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/index', type: :view do
  let(:current_user) do
    User.create!(name: 'Admin User', email: 'admin@example.com', password: 'password', matricula: '00000',
                 role: 'admin')
  end
  let(:users) do
    [
      User.create!(name: 'João Silva', email: 'joao@example.com', password: 'password', matricula: '12345',
                   role: 'admin'),
      User.create!(name: 'Maria Santos', email: 'maria@example.com', password: 'password', matricula: '67890',
                   role: 'professor')
    ]
  end

  before do
    assign(:users, users)
    allow(view).to receive(:current_user).and_return(current_user)
  end

  it 'renders a list of users' do
    render
    expect(rendered).to include('João Silva')
    expect(rendered).to include('Maria Santos')
  end

  it 'shows user roles' do
    render
    expect(rendered).to include('admin')
    expect(rendered).to include('professor')
  end

  it 'contains links to show each user' do
    render
    users.each do |user|
      expect(rendered).to include(user_path(user))
    end
  end
end
