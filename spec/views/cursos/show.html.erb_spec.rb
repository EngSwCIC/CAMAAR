# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'cursos/show', type: :view do
  before do
    assign(:curso, Curso.create!(
                     nome: 'Nome'
                   ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Nome/)
  end
end
