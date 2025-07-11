# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/new', type: :view do
  before do
    assign(:user, User.new(
                    email: 'MyString',
                    password: 'secret123',
                    name: 'MyString',
                    matricula: 'MyString',
                    role: 1
                  ))
  end

  it 'renders new user form' do
    render

    assert_select 'form[action=?][method=?]', users_path, 'post' do
      assert_select 'input[name=?]', 'user[email]'

      assert_select 'input[name=?]', 'user[password]'

      assert_select 'input[name=?]', 'user[name]'

      assert_select 'input[name=?]', 'user[matricula]'

      assert_select 'input[name=?]', 'user[role]'
    end
  end
end
