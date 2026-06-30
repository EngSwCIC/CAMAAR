require 'rails_helper'

RSpec.describe "Redefinição de senha", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "solicita a redefinição de senha com sucesso" do
    user = User.create!(
      nome: "Aluno Esquecido",
      matricula: "190012345",
      email: "esquecido@camaar.com",
      password: "senha_antiga",
      perfil: "discente"
    )

    visit new_user_session_path
    click_link "Forgot your password?"
    fill_in "Email", with: user.email
    click_button "Send me password reset instructions"
    expect(page).to have_text("You will receive an email with instructions")
  end

  it "altera a senha com sucesso usando o link do email" do
    user = User.create!(
      nome: "Aluno Recuperado",
      matricula: "190054321",
      email: "recuperado@camaar.com",
      password: "senha_antiga",
      perfil: "discente"
    )

    token = user.send_reset_password_instructions

    visit edit_user_password_path(reset_password_token: token)

    fill_in "New password", with: "senha_nova_123"
    fill_in "Confirm new password", with: "senha_nova_123"
    click_button "Change my password"

    expect(page).to have_text("Your password has been changed successfully")
  end

  it "exibe erro quando as senhas não coincidem durante a redefinição" do
    user = User.create!(
      nome: "Aluno Errado",
      matricula: "190099999",
      email: "erro@camaar.com",
      password: "senha_antiga",
      perfil: "discente"
    )

    token = user.send_reset_password_instructions

    visit edit_user_password_path(reset_password_token: token)

    fill_in "New password", with: "senha_nova_123"
    fill_in "Confirm new password", with: "senha_diferente_456"
    click_button "Change my password"

    expect(page).to have_text("doesn't match")
    expect(user.reload.valid_password?("senha_antiga")).to be true
  end
end
