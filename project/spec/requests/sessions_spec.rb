require "rails_helper"

RSpec.describe "Login" do
  before do
    create(:user, :admin, name: "Admin CIC", email: "admin.cic@unb.br", registration: "000000001")
    create(:user, name: "Ana Clara Jordao Perna", email: "acjpjvjp@gmail.com", registration: "190084006", password: "Senha@123")
    create(:user, name: "Andre Carvalho de Roure", email: "andreCarvalhoroure@gmail.com", registration: "200033522", password: nil)
  end

  it "autentica administrador com email e exibe menu administrativo" do
    post login_path, params: { session: { identifier: "admin.cic@unb.br", password: "Senha@123" } }

    expect(response).to redirect_to(root_path)
    follow_redirect!
    expect(response.body).to include("Gerenciar templates")
    expect(response.body).to include("Gerenciar formularios")
  end

  it "autentica participante com matricula e exibe menu de participante" do
    post login_path, params: { session: { identifier: "190084006", password: "Senha@123" } }

    expect(response).to redirect_to(root_path)
    follow_redirect!
    expect(response.body).to include("Formularios pendentes")
    expect(response.body).not_to include("Gerenciar templates")
  end

  it "nao autentica usuario com senha incorreta" do
    post login_path, params: { session: { identifier: "acjpjvjp@gmail.com", password: "SenhaErrada" } }

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("Email, matricula ou senha invalidos")
  end

  it "nao autentica usuario ainda sem senha definida" do
    post login_path, params: { session: { identifier: "200033522", password: "Senha@123" } }

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("Senha inicial precisa ser definida antes do acesso")
  end
end
