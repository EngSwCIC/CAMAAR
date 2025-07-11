# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  before do
    user = User.create!(
      email: 'test@example.com',
      password: 'secret123',
      name: 'Test User',
      matricula: '123456',
      role: 2
    )
    assign(:user, user)
    allow(view).to receive_messages(current_user: user, user_signed_in?: true)
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/test@example.com/)
    expect(rendered).to match(/Test User/)
    expect(rendered).to match(/123456/)
  end
end
