require 'rails_helper'

RSpec.feature "Login", type: :feature do

  let!(:pessoa) do
    Pessoa.where(email: "aluna@example.com").destroy_all
    Pessoa.create!(
      email: "aluna@example.com",
      nome: "Fulana de Tal",
      matricula: "2023001234",
      password: "senha123",
      password_confirmation: "senha123"
    )
  end

  scenario "usuária faz login com e-mail e senha" do
    visit new_pessoa_session_path

    fill_in "Email ou Matrícula", with: "aluna@example.com"
    fill_in "Senha", with: "senha123"
    click_button "Entrar"

    expect(page).to have_content("Login efetuado com sucesso")
  end

  scenario "usuária faz login com matrícula e senha" do
    visit new_pessoa_session_path

    fill_in "Email ou Matrícula", with: "2023001234"
    fill_in "Senha", with: "senha123"
    click_button "Entrar"

    expect(page).to have_content("Login efetuado com sucesso")
  end

  scenario "login com credenciais inválidas" do
    visit new_pessoa_session_path

    fill_in "Email ou Matrícula", with: "emailerrado@example.com"
    fill_in "Senha", with: "senhaerrada"
    click_button "Entrar"

    expect(page).to have_content("Login ou senha inválidos")
  end
end
