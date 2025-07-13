require 'rails_helper'

RSpec.feature "Login System", type: :feature do
  let!(:regular_user) do
    User.create!(
      email: "user@gmail.com",
      registration_number: "012345678",
      password: "pass01",
      password_confirmation: "pass01",
      role: "user"
    )
  end

  let!(:admin_user) do
    User.create!(
      email: "admin@gmail.com",
      password: "admin1",
      password_confirmation: "admin1",
      role: "admin"
    )
  end

  background do
    visit login_path
  end

  scenario "Successful login with email and password (regular user)" do
    fill_in "Email ou Número de Matrícula", with: "user@gmail.com"
    fill_in "Senha", with: "pass01"
    click_button "Entrar"

    expect(page).to have_current_path(forms_dashboard_path)
    expect(page).to have_content("Painel de Formulários")
    expect(page).not_to have_css("#management-option")
  end

  scenario "Successful login with registration number and password (regular user)" do
    fill_in "Email ou Número de Matrícula", with: "012345678"
    fill_in "Senha", with: "pass01"
    click_button "Entrar"

    expect(page).to have_current_path(forms_dashboard_path)
    expect(page).to have_content("Painel de Formulários")
    expect(page).not_to have_css("#management-option")
  end

  scenario "Successful login with admin credentials" do
    fill_in "Email ou Número de Matrícula", with: "admin@gmail.com"
    fill_in "Senha", with: "admin1"
    click_button "Entrar"

    expect(page).to have_current_path(forms_dashboard_path)
    expect(page).to have_content("Painel de Formulários")
    expect(page).to have_css("#management-option")
  end

  scenario "Failed login with unregistered email" do
    fill_in "Email ou Número de Matrícula", with: "notfound@example.com"
    fill_in "Senha", with: "any"
    click_button "Entrar"

    expect(page).to have_current_path(login_path)
    expect(page).to have_content("Email/matrícula ou senha inválidos")
  end

  scenario "Failed login with incorrect password" do
    fill_in "Email ou Número de Matrícula", with: "user@gmail.com"
    fill_in "Senha", with: "wrong1"
    click_button "Entrar"

    expect(page).to have_current_path(login_path)
    expect(page).to have_content("Email/matrícula ou senha inválidos")
  end
end