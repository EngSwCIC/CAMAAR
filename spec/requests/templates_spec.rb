require 'rails_helper'

RSpec.describe "Templates", type: :request do
  # 1. Criação dos utilizadores de teste
  let(:discente_user) { User.create!(email: "aluno_temp#{rand(1000)}@unb.br", password: "password123", perfil: "Discente", nome: "Aluno", matricula: "111222") }
  let(:admin_user) { User.create!(email: "admin_temp#{rand(1000)}@unb.br", password: "password123", perfil: "Administrador", nome: "Admin", matricula: "333444") }

  describe "GET /templates" do
    context "Cenário 1: quando o usuário NÃO está logado" do
      it "é barrado pelo before_action :require_login e redirecionado para o login" do
        get templates_path

        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq("Você precisa estar logado.")
      end
    end

    context "Cenário 2: quando o usuário é um Discente (NÃO é admin)" do
      before do
        # Simula a sessão de um utilizador comum
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(discente_user)
      end

      it "é barrado pelo before_action :require_admin e redirecionado para o dashboard" do
        get templates_path

        expect(response).to redirect_to(discente_dashboard_path)
        expect(flash[:alert]).to eq("Você não tem permissão para acessar esta página")
      end
    end

    context "Cenário 3: quando o usuário é um Administrador (Fluxo de Sucesso)" do
      before do
        # Simula a sessão de um Administrador
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_user)

        # Usamos um mock na associação de templates para focar apenas na cobertura do Controller
        templates_mock = double("templates")
        allow(templates_mock).to receive(:order).with(created_at: :desc).and_return([])
        allow(admin_user).to receive(:templates).and_return(templates_mock)
      end

      it "passa por todas as validações e carrega o index com sucesso" do
        get templates_path

        expect(response).to have_http_status(:success)
      end
    end
  end
end
