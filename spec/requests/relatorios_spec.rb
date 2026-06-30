require "rails_helper"

RSpec.describe "Gerar Relatório do Administrador", type: :request do
  let(:departamento) { Departamento.create!(nome_departamento: "CIC Rel") }
  let(:admin_u) do
    Usuario.create!(nome: "Admin Rel", email: "admin-relspec@example.com",
      password: "Senha123", password_confirmation: "Senha123", role: :admin)
  end
  let!(:admin) { Admin.create!(usuario: admin_u, departamento: departamento) }
  let!(:criador) { CriadorFormulario.create!(usuario: admin_u) }
  let(:materia) { Materia.create!(codigoMateria: "REL01", nome_materia: "Rel Materia", departamento: departamento) }
  let(:prof_u) do
    Usuario.create!(nome: "Prof Rel", email: "prof-relspec@example.com",
      password: "Senha123", password_confirmation: "Senha123", role: :professor)
  end
  let(:professor) { Professor.create!(usuario: prof_u) }
  let(:turma) { Turma.create!(numero_turma: 1, semestre_string: "2026/1", materia: materia, professor: professor) }
  let(:template) { TemplateFormulario.create!(nome_template: "T Rel", criador_formulario: criador) }
  let(:formulario) { Formulario.create!(nome_formulario: "Form Relatorio", turma: turma, criador_formulario: criador, template_formulario: template) }
  let(:student_u) do
    Usuario.create!(nome: "Aluno Rel", email: "aluno-relspec@example.com",
      password: "Senha123", password_confirmation: "Senha123", role: :estudante)
  end

  def login_as(usuario)
    post login_path, params: { email: usuario.email, password: "Senha123" }
  end

  describe "Administrador gera relatório" do
    it "exibe o relatório de formulário com respostas" do
      RespostaFormulario.create!(formulario: formulario, usuario: student_u, data_resposta: Time.current)
      login_as(admin_u)

      get relatorio_path(formulario)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Form Relatorio")
      expect(response.body).to include("Total de respostas")
    end
  end

  describe "Administrador exporta CSV" do
    it "realiza download de CSV com respostas" do
      RespostaFormulario.create!(formulario: formulario, usuario: student_u, data_resposta: Time.current)
      login_as(admin_u)

      get export_csv_relatorio_path(formulario)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("text/csv")
      expect(response.body).to include(student_u.email)
    end
  end

  describe "Formulário sem respostas" do
    it "exibe mensagem informando ausência de respostas" do
      login_as(admin_u)

      get relatorio_path(formulario)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Não há respostas registradas")
    end
  end

  describe "Estudante não pode acessar relatórios" do
    it "nega o acesso com status 403" do
      login_as(student_u)

      get relatorios_path

      expect(response).to have_http_status(:forbidden)
      expect(response.body).to include("permiss")
    end
  end
end
