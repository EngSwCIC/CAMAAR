require 'rails_helper'

RSpec.describe "Buscar template", type: :system do
  before do
    driven_by(:rack_test)

    admin = User.create!(
      nome: "Admin",
      email: "admin@teste.com",
      password: "password123",
      matricula: "100000000",
      perfil: "docente"
    )
    login_as(admin, scope: :user)

    Template.create!(nome: "Avaliação de Disciplina")
    Template.create!(nome: "Avaliação de Docente")
  end

  it "filtra a listagem pelo termo buscado" do
    visit templates_path

    fill_in "q", with: "Disciplina"
    click_button "Buscar"

    expect(page).to have_text("Avaliação de Disciplina")
    expect(page).not_to have_text("Avaliação de Docente")
  end

  it "exibe mensagem quando nada é encontrado" do
    visit templates_path

    fill_in "q", with: "Inexistente"
    click_button "Buscar"

    expect(page).to have_text('Nenhum template encontrado para "Inexistente".')
  end

  it "lista todos os templates sem termo de busca" do
    visit templates_path

    expect(page).to have_text("Avaliação de Disciplina")
    expect(page).to have_text("Avaliação de Docente")
  end
end
