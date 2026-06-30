require 'rails_helper'

RSpec.describe "PendingRegistrations", type: :request do
  let!(:pending) do
    PendingRegistration.create!(email: "convidado@unb.br", token: "tok-abc", nome: "Convidado", matricula: "555", perfil: "discente")
  end

  describe "GET /users/password/define" do
    it "renderiza a definição de senha quando o token é válido (Happy Path)" do
      get "/users/password/define", params: { token: "tok-abc" }
      expect(response).to have_http_status(:success)
    end

    it "redireciona com alerta quando o token é inválido (Sad Path)" do
      get "/users/password/define", params: { token: "inexistente" }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Link inválido")
    end
  end

  describe "POST /users/password/define" do
    it "cria o usuário, remove o pendente e redireciona (Happy Path)" do
      expect {
        post "/users/password/define", params: { token: "tok-abc", senha: "password123" }
      }.to change(User, :count).by(1).and change(PendingRegistration, :count).by(-1)

      expect(response).to redirect_to(users_path)
      expect(flash[:notice]).to eq("Cadastro concluído com sucesso.")
      expect(User.last.email).to eq("convidado@unb.br")
    end

    it "redireciona com alerta quando o token é inválido (Sad Path)" do
      post "/users/password/define", params: { token: "inexistente", senha: "password123" }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Link inválido")
    end

    it "gera nome e matrícula a partir do e-mail quando o pendente não os possui" do
      sem_dados = PendingRegistration.create!(email: "semdados@unb.br", token: "tok-sd")
      post "/users/password/define", params: { token: "tok-sd", senha: "password123" }

      criado = User.find_by(email: "semdados@unb.br")
      expect(criado.nome).to eq("semdados")
      expect(criado.matricula).to be_present
    end
  end
end
