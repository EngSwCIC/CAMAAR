require "rails_helper"

RSpec.describe "Definicao de senha" do
  let(:user) do
    create(:user, name: "Ana Clara Jordao Perna", email: "acjpjvjp@gmail.com", registration: "190084006", password: nil)
  end

  it "define a primeira senha com link valido e permite login" do
    token = user.generate_password_setup_token!

    patch password_setup_path(token),
      params: { user: { password: "Senha@123", password_confirmation: "Senha@123" } }

    expect(response).to redirect_to(login_path)
    user.reload
    expect(user).not_to be_pending_password_setup
    expect(user.authenticate("Senha@123")).to eq(user)

    post login_path, params: { session: { identifier: "190084006", password: "Senha@123" } }
    expect(response).to redirect_to(root_path)
  end

  it "nao permite definicao com link invalido" do
    get edit_password_setup_path("token-invalido")

    expect(response).to have_http_status(:not_found)
    expect(response.body).to include("Link de definição de senha inválido ou expirado")
  end

  it "nao salva senha quando a confirmacao e diferente" do
    token = user.generate_password_setup_token!

    patch password_setup_path(token),
      params: { user: { password: "Senha@123", password_confirmation: "OutraSenha@123" } }

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("Confirmação de senha não confere")
    expect(user.reload).to be_pending_password_setup
  end
end
