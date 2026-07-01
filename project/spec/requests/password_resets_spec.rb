require "rails_helper"

RSpec.describe "Redefinicao de senha" do
  let!(:user) do
    create(:user, name: "Ana Clara Jordao Perna", email: "acjpjvjp@gmail.com", registration: "190084006", password: "Senha@123")
  end

  it "redefine a senha com token valido e permite login com a nova senha" do
    post password_resets_path, params: { password_reset: { email: "acjpjvjp@gmail.com" } }

    expect(response).to redirect_to(new_password_reset_path)
    expect(ActionMailer::Base.deliveries.last.to).to include("acjpjvjp@gmail.com")

    token = extract_token_from(ActionMailer::Base.deliveries.last.body.encoded, "senha/redefinir")
    patch password_reset_path(token),
      params: { user: { password: "NovaSenha@123", password_confirmation: "NovaSenha@123" } }

    expect(response).to redirect_to(login_path)
    expect(user.reload.authenticate("NovaSenha@123")).to eq(user)

    post login_path, params: { session: { identifier: "acjpjvjp@gmail.com", password: "NovaSenha@123" } }
    expect(response).to redirect_to(root_path)
  end

  it "nao revela se email inexistente esta cadastrado" do
    expect do
      post password_resets_path, params: { password_reset: { email: "naoexiste@unb.br" } }
    end.not_to change { User.where.not(password_reset_token_digest: nil).count }

    expect(response).to redirect_to(new_password_reset_path)
    follow_redirect!
    expect(response.body).to include(PasswordResetsController::GENERIC_MESSAGE)
    expect(ActionMailer::Base.deliveries).to be_empty
  end

  it "nao redefine senha com token expirado" do
    token = user.generate_password_reset_token!
    user.update!(password_reset_sent_at: 3.hours.ago)

    patch password_reset_path(token),
      params: { user: { password: "NovaSenha@123", password_confirmation: "NovaSenha@123" } }

    expect(response).to have_http_status(:not_found)
    expect(response.body).to include("Link de redefinição de senha inválido ou expirado")
    expect(user.reload.authenticate("Senha@123")).to eq(user)
    expect(user.authenticate("NovaSenha@123")).to be(false)
  end

  it "nao redefine senha quando a confirmacao nao confere" do
    token = user.generate_password_reset_token!

    patch password_reset_path(token),
      params: { user: { password: "NovaSenha@123", password_confirmation: "SenhaErrada@123" } }

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("Confirmação de senha não confere")
    expect(user.reload.authenticate("Senha@123")).to eq(user)
  end

  it "exibe o formulario de redefinicao de senha com token valido" do
    token = user.generate_password_reset_token!

    get edit_password_reset_path(token)

    expect(response).to have_http_status(:success)
  end

  def extract_token_from(body, segment)
    body.match(%r{#{segment}/([^"\s<]+)})[1]
  end
end
