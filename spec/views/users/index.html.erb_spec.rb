# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/index', type: :view do
  before do
    admin_user = FactoryBot.create(:user, role: 0)
    assign(:users, [
             FactoryBot.create(:user),
             FactoryBot.create(:user)
           ])
    allow(view).to receive_messages(current_user: admin_user, user_signed_in?: true)
  end

  it 'renders a list of users' do
    render
    # Verifica se a página contém elementos de usuários
    expect(rendered).to match(/E-mail/)
    expect(rendered).to match(/Nome/)
    expect(rendered).to match(/Matrícula/)
    expect(rendered).to match(/Tipo/)
  end
end
