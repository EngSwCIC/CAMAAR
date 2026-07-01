require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }

  let!(:admin) do
    Administrador.create!(
      nome: "Admin Teste",
      matricula: "adm001",
      email: "admin@unb.br",
      senha: "Senha123",
      senha_confirmation: "Senha123",
      departamento: departamento
    )
  end

  let!(:docente) do
    Docente.create!(
      nome: "Prof Teste",
      matricula: "doc001",
      email: "prof@unb.br",
      formacao: "Doutorado",
      senha: "Senha123",
      senha_confirmation: "Senha123"
    )
  end

  describe "GET /" do
    context "quando não está logado" do
      it "exibe a tela de login" do
        get root_path
        expect(response).to have_http_status(:ok)
      end
    end

    context "quando já está logado como Administrador" do
      before { post login_path, params: { login: admin.email, senha: "Senha123" } }

      it "redireciona para a página de avaliações do admin" do
        get root_path
        expect(response).to redirect_to(admin_avaliacoes_path(admin.id))
      end
    end

    context "quando já está logado como usuário comum" do
      before { post login_path, params: { login: docente.email, senha: "Senha123" } }

      it "redireciona para a página do usuário" do
        get root_path
        expect(response).to redirect_to(usuarios_avaliacoes_path(docente.id))
      end
    end
  end

  describe "POST /login" do
    context "com credenciais inválidas" do
      it "redireciona para root com alerta quando login está em branco" do
        post login_path, params: { login: "", senha: "Senha123" }
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("informe seu email ou matrícula")
      end

      it "redireciona para root com alerta quando senha está em branco" do
        post login_path, params: { login: docente.email, senha: "" }
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("informe a sua senha")
      end

      it "redireciona para root com alerta quando usuário não existe" do
        post login_path, params: { login: "naoexiste@unb.br", senha: "Senha123" }
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("usuário não encontrado")
      end

      it "redireciona para root com alerta quando senha está incorreta" do
        post login_path, params: { login: docente.email, senha: "errada" }
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("senha incorreta")
      end
    end

    context "com credenciais válidas de Administrador" do
      it "redireciona para a página de avaliações do admin" do
        post login_path, params: { login: admin.email, senha: "Senha123" }
        expect(response).to redirect_to(admin_avaliacoes_path(admin.id))
      end

      it "aceita login pela matrícula" do
        post login_path, params: { login: admin.matricula, senha: "Senha123" }
        expect(response).to redirect_to(admin_avaliacoes_path(admin.id))
      end
    end

    context "com credenciais válidas de usuário comum" do
      it "redireciona para a página do usuário" do
        post login_path, params: { login: docente.email, senha: "Senha123" }
        expect(response).to redirect_to(usuarios_avaliacoes_path(docente.id))
      end

      it "aceita login pela matrícula" do
        post login_path, params: { login: docente.matricula, senha: "Senha123" }
        expect(response).to redirect_to(usuarios_avaliacoes_path(docente.id))
      end
    end
  end

  describe "DELETE /logout" do
    before { post login_path, params: { login: docente.email, senha: "Senha123" } }

    it "redireciona para a raiz" do
      delete logout_path
      expect(response).to redirect_to(root_path)
    end

    it "encerra a sessão e exige novo login para rotas protegidas" do
      delete logout_path
      get inicio_path
      expect(response).to redirect_to(root_path)
    end
  end
end
