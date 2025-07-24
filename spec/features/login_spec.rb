require 'rails_helper'

RSpec.feature "Login System", type: :feature do
  let!(:regular_user) do
    User.create!(
      nome: "Aluno Teste",
      email: "aluno@teste.com",
      matricula: "012345678",
      password: "12345678",
      password_confirmation: "12345678",
      ocupacao: "discente"
    )
  end

  let!(:admin_user) do
    User.create!(
      nome: "Admin Teste",
      email: "admin@teste.com",
      password: "12345678",
      password_confirmation: "12345678",
      ocupacao: "admin"
    )
  end

  background do
    visit login_path
  end

  scenario "Login bem-sucedido com email (usuário regular)" do
    fill_in "Email", with: "aluno@teste.com"
    fill_in "Senha", with: "12345678"
    click_button "Entrar"

    expect(page).to have_current_path(user_templates_path)
  end

  scenario "Login bem-sucedido com matrícula (usuário regular)" do
    fill_in "Email", with: "012345678"
    fill_in "Senha", with: "12345678"
    click_button "Entrar"

    expect(page).to have_current_path(user_templates_path)
  end

  scenario "Login admin bem-sucedido" do
    fill_in "Email", with: "admin@teste.com"
    fill_in "Senha", with: "12345678"
    click_button "Entrar"

    expect(page).to have_current_path(admin_templates_path)
    #expect(page).to have_link("Avaliações")
  end

  scenario "Login falho com credenciais inválidas" do
    fill_in "Email", with: "naoexiste@teste.com"
    fill_in "Senha", with: "senhainvalida"
    click_button "Entrar"

    expect(page).to have_current_path(login_path)
    expect(page).to have_content("Email/matrícula ou senha inválidos")
  end
end
