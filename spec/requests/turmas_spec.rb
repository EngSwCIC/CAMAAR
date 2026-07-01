require "rails_helper"

RSpec.describe "Turmas", type: :request do
  SENHA = "senha123".freeze

  let!(:departamento_a) { Departamento.create!(nome: "Fábrica de Software") }
  let!(:departamento_b) { Departamento.create!(nome: "Engenharia Elétrica") }
  let!(:departamento_c) { Departamento.create!(nome: "Ciência da Computação") }

  let!(:turma_a1) { Turma.create!(departamento: departamento_a, codigo: "FGA0001", nome: "Engenharia de Software") }
  let!(:turma_a2) { Turma.create!(departamento: departamento_a, codigo: "FGA0002", nome: "Estrutura de Dados") }
  let!(:turma_b1) { Turma.create!(departamento: departamento_b, codigo: "ENE0001", nome: "Circuitos Elétricos") }

  let!(:admin_a) do
    user = User.create!(
      nome: "Admin A",
      email: "admin_a@camaar.com",
      matricula: "100000001",
      perfil: "Administrador",
      password: SENHA,
      password_confirmation: SENHA,
      primeiro_acesso: false
    )
    Admin.create!(user: user, departamento: departamento_a)
    user
  end

  let!(:admin_b) do
    user = User.create!(
      nome: "Admin B",
      email: "admin_b@camaar.com",
      matricula: "100000002",
      perfil: "Administrador",
      password: SENHA,
      password_confirmation: SENHA,
      primeiro_acesso: false
    )
    Admin.create!(user: user, departamento: departamento_c)
    user
  end

  let!(:admin_multi) do
    user = User.create!(
      nome: "Admin Multi",
      email: "admin_multi@camaar.com",
      matricula: "100000003",
      perfil: "Administrador",
      password: SENHA,
      password_confirmation: SENHA,
      primeiro_acesso: false
    )
    Admin.create!(user: user, departamento: departamento_a)
    Admin.create!(user: user, departamento: departamento_b)
    user
  end

  let!(:discente) do
    User.create!(
      nome: "Discente",
      email: "discente@camaar.com",
      matricula: "200000001",
      perfil: "Discente",
      password: SENHA,
      password_confirmation: SENHA,
      primeiro_acesso: false
    )
  end

  def login_as(user)
    post "/login", params: { identifier: user.email, password: SENHA }
  end

  describe "GET /turmas" do
    context "como administrador de um departamento com turmas" do
      it "lista apenas as turmas do próprio departamento" do
        login_as(admin_a)

        get "/turmas"

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("FGA0001")
        expect(response.body).to include("FGA0002")
        expect(response.body).not_to include("ENE0001")
      end
    end

    context "como administrador de um departamento sem turmas" do
      it "informa que não há dados disponíveis" do
        login_as(admin_b)

        get "/turmas"

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Não há dados disponíveis")
      end
    end

    context "como administrador associado a múltiplos departamentos" do
      it "lista as turmas de todos os departamentos vinculados" do
        login_as(admin_multi)

        get "/turmas"

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("FGA0001")
        expect(response.body).to include("ENE0001")
      end
    end

    context "como discente" do
      it "não permite acesso à área de gerenciamento" do
        login_as(discente)

        get "/turmas"

        expect(response).to redirect_to(root_path)
      end
    end

    context "sem autenticação" do
      it "redireciona para o login" do
        get "/turmas"

        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "GET /turmas/:id" do
    context "quando a turma pertence ao departamento do administrador" do
      it "exibe os dados correspondentes" do
        login_as(admin_a)

        get "/turmas/#{turma_a1.id}"

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(turma_a1.codigo)
        expect(response.body).to include(turma_a1.nome)
      end
    end

    context "quando a turma não pertence ao departamento do administrador" do
      it "informa que não há dados disponíveis" do
        login_as(admin_a)

        get "/turmas/#{turma_b1.id}"

        expect(response).to have_http_status(:ok)
        expect(response.body).not_to include(turma_b1.codigo)
        expect(response.body).to include("Não há dados disponíveis")
      end
    end
  end
end
