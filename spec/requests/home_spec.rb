require 'rails_helper'

RSpec.describe "Home", type: :request do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let!(:docente) do
    Docente.create!(
      nome: "Docente Home",
      matricula: "doc_home",
      email: "doc_home@unb.br",
      formacao: "Doutorado",
      senha: "Senha123",
      senha_confirmation: "Senha123"
    )
  end

  describe "GET /inicio" do
    context "sem sessão ativa" do
      it "redireciona para a tela de login" do
        get inicio_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "com sessão ativa" do
      before { post login_path, params: { login: docente.email, senha: "Senha123" } }

      it "retorna 200 OK" do
        get inicio_path
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
