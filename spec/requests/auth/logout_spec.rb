require "rails_helper"

RSpec.describe "Auth Logout", type: :request do
  let(:usuario_mock) { double("Usuario", id: 1) }

  describe "DELETE /logout" do
    it "Adiciona dados na sessão, limpa a sessão, desloga o usuário e redireciona" do
      # 1. Simulamos o login no Controller
      allow_any_instance_of(ApplicationController)
        .to receive(:current_user)
        .and_return(usuario_mock)

      # 2. ESPIANDO A SESSÃO:
      # Criamos um mock específico para interceptar a chamada do session.clear no controller
      sessao_mock = double("Session")
      expect(sessao_mock).to receive(:clear).at_least(:once)

      # Forçamos o controller a devolver o nosso dublê quando ele chamar o método `session`
      allow_any_instance_of(ApplicationController)
        .to receive(:session)
        .and_return(sessao_mock)

      # 3. Dispara a requisição de logout
      delete logout_path

      # 4. Verificações de redirecionamento e flash
      expect(response).to redirect_to(root_path)
      expect(flash[:success]).to eq("Sessão encerrada com sucesso.")
    end
  end
end
