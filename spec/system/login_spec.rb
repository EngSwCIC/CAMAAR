require "rails_helper"

RSpec.describe "Sistema de Login", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "permite login de discente e não mostra gerenciamento" do
    User.create!(
      nome: "Discente Teste",
      email: "discente_teste@camaar.com",
      matricula: "202400002",
      perfil: "Discente",
      password: "123456"
    )

    visit login_path

    fill_in "E-mail ou matrícula", with: "discente_teste@camaar.com"
    fill_in "Senha", with: "123456"
    click_button "Entrar"

    expect(page).to have_content("Perfil de Discente")
    expect(page).not_to have_content("Gerenciamento")
  end

  it "permite login de administrador e mostra gerenciamento" do
    User.create!(
      nome: "Administrador Teste",
      email: "admin_teste@camaar.com",
      matricula: "000000002",
      perfil: "Administrador",
      password: "123456"
    )

    visit login_path

    fill_in "E-mail ou matrícula", with: "admin_teste@camaar.com"
    fill_in "Senha", with: "123456"
    click_button "Entrar"

    expect(page).to have_content("Perfil de Administrador")
    expect(page).to have_content("Gerenciamento")
  end

  it "exibe erro para usuário inexistente" do
    visit login_path

    fill_in "E-mail ou matrícula", with: "naoexiste@camaar.com"
    fill_in "Senha", with: "qualquer"
    click_button "Entrar"

    expect(page).to have_content("Usuário e/ou senha inválidos")
  end

  it "exibe erro para senha incorreta" do
    User.create!(
      nome: "Discente Teste",
      email: "discente_senha_errada@camaar.com",
      matricula: "202400003",
      perfil: "Discente",
      password: "123456"
    )

    visit login_path

    fill_in "E-mail ou matrícula", with: "discente_senha_errada@camaar.com"
    fill_in "Senha", with: "senhaerrada"
    click_button "Entrar"

    expect(page).to have_content("Usuário e/ou senha inválidos")
  end
end