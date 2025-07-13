require "rails_helper"

RSpec.feature "Login", type: :feature do
  scenario "visitando a tela de login" do
    visit login_path  # Usando o helper de rota
    expect(page).to have_content("Login")  # Texto exato que você espera na página
  end
end