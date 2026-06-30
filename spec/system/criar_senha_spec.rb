require 'rails_helper'

RSpec.describe "Criar senha a partir do convite", type: :system do
  before { driven_by(:rack_test) }

  it "permite ao usuário convidado definir sua senha" do
    user = User.invite!(nome: "Novo Usuário", email: "novo@teste.com",
                        matricula: "200000000", perfil: "discente")
    token = user.raw_invitation_token

    visit accept_user_invitation_path(invitation_token: token)

    fill_in "Senha", with: "novasenha123"
    fill_in "Confirmação da senha", with: "novasenha123"
    click_button "Definir senha"

    expect(user.reload.invitation_accepted?).to be true
  end

  it "exibe erro quando a confirmação da senha não coincide" do
    user = User.invite!(nome: "Novo Usuário", email: "outro@teste.com",
                        matricula: "200000001", perfil: "discente")
    token = user.raw_invitation_token

    visit accept_user_invitation_path(invitation_token: token)

    fill_in "Senha", with: "senha123"
    fill_in "Confirmação da senha", with: "diferente456"
    click_button "Definir senha"

    expect(page).to have_text("Password confirmation doesn't match Password")
    expect(page).to have_text("doesn't match")
  end
end
