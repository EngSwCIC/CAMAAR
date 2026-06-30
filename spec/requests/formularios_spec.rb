require "rails_helper"

RSpec.describe "FormulariosController", type: :request do
  let(:departamento) { Departamento.create!(nome_departamento: "CIC Fspec") }
  let(:admin_u) do
    Usuario.create!(nome: "Admin Fspec", email: "admin-fspec@example.com",
      password: "Senha123", password_confirmation: "Senha123", role: :admin)
  end
  let!(:admin) { Admin.create!(usuario: admin_u, departamento: departamento) }
  let!(:criador) { CriadorFormulario.create!(usuario: admin_u) }
  let(:prof_u) do
    Usuario.create!(nome: "Prof Fspec", email: "prof-fspec@example.com",
      password: "Senha123", password_confirmation: "Senha123", role: :professor)
  end
  let(:professor) { Professor.create!(usuario: prof_u) }
  let(:materia) { Materia.create!(codigoMateria: "FSPEC1", nome_materia: "FSpec Materia", departamento: departamento) }
  let(:turma) { Turma.create!(numero_turma: 1, semestre_string: "2026/1", materia: materia, professor: professor) }
  let(:template) { TemplateFormulario.create!(nome_template: "T Fspec", criador_formulario: criador) }
  let!(:formulario_pub) do
    Formulario.create!(nome_formulario: "Form Fspec Pub", turma: turma,
      criador_formulario: criador, template_formulario: template, publico_estudante: true)
  end
  let(:student_u) do
    Usuario.create!(nome: "Aluno Fspec", email: "aluno-fspec@example.com",
      password: "Senha123", password_confirmation: "Senha123", role: :estudante)
  end
  let!(:estudante) { Estudante.create!(usuario: student_u) }
  let!(:matricula) { Matricula.create!(estudante: estudante, turma: turma, trancado: false) }

  def login_as(usuario)
    post login_path, params: { email: usuario.email, password: "Senha123" }
  end

  describe "GET /formularios (index)" do
    it "visitante não autenticado é redirecionado para login" do
      get formularios_path
      expect(response).to redirect_to(login_path)
    end

    it "estudante com matrícula ativa vê seus formulários públicos" do
      login_as(student_u)
      get formularios_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Form Fspec Pub")
    end

    it "usuário sem perfil de estudante vê lista vazia" do
      login_as(admin_u)
      get formularios_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Não há formulários disponíveis")
    end
  end

  describe "GET /formularios/:id (show)" do
    it "estudante matriculado acessa formulário público com sucesso" do
      login_as(student_u)
      get formulario_path(formulario_pub)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Form Fspec Pub")
    end

    it "usuário sem perfil de estudante é redirecionado com alerta de permissão" do
      login_as(admin_u)
      get formulario_path(formulario_pub)
      expect(response).to redirect_to(avaliacoes_path)
      follow_redirect!
      expect(response.body).to include("permissão")
    end
  end
end
