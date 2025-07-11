# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'cursos/new', type: :view do
  before do
    assign(:curso, Curso.new(
                     nome: 'MyString'
                   ))
  end

  it 'renders new curso form' do
    render

    assert_select 'form[action=?][method=?]', cursos_path, 'post' do
      assert_select 'input[name=?]', 'curso[nome]'
    end
  end
end
