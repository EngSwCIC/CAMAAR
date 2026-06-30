require 'rails_helper'

RSpec.describe "PasswordRedefinition", type: :request do
  describe "GET /password/edit" do
    it "renderiza a página de redefinição com token normal (Happy Path)" do
      get "/password/edit", params: { token: "tok-normal" }
      expect(response).to have_http_status(:success)
    end

    it "renderiza a página de link expirado quando o token é 'expired' (Sad Path)" do
      get "/password/edit", params: { token: "expired" }
      expect(response).to have_http_status(:success)
      expect(response.body).to be_present
    end

    it "renderiza a página de link inválido quando o token já foi usado (Sad Path)" do
      PasswordResetUsage.create!(token: "ja-usado")
      get "/password/edit", params: { token: "ja-usado" }
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /password/update" do
    let!(:user) do
      User.create!(
        email: "reset@unb.br", password: "antiga123", nome: "Reset", matricula: "881", perfil: "discente",
        reset_password_sent_at: Time.current
      )
    end

    it "redefine a senha com sucesso e marca o token como usado (Happy Path)" do
      expect {
        post "/password/update", params: { token: "tok-ok", nova_senha: "novaSenha1", confirmar_senha: "novaSenha1" }
      }.to change(PasswordResetUsage, :count).by(1)

      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:notice]).to match(/redefinida com sucesso/)
      expect(user.reload.valid_password?("novaSenha1")).to be(true)
    end

    it "recusa quando as senhas não coincidem (Sad Path)" do
      post "/password/update", params: { token: "tok-x", nova_senha: "abcdef1", confirmar_senha: "diferente1" }
      expect(response).to have_http_status(:redirect)
      expect(flash[:alert]).to eq("As senhas não coincidem")
    end

    it "recusa quando a senha é curta demais (Sad Path)" do
      post "/password/update", params: { token: "tok-y", nova_senha: "123", confirmar_senha: "123" }
      expect(response).to have_http_status(:redirect)
      expect(flash[:alert]).to eq("Senha não atende aos requisitos mínimos")
    end
  end
end
