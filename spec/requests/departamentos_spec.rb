require "rails_helper"

RSpec.describe "Gerenciamento por Departamento", type: :request do
  let(:departamento) { Departamento.create!(nome_departamento: "CIC") }
  let(:admin_usuario) do
    Usuario.create!(nome: "Admin Depto", email: "admin-depto@example.com",
      password: "Senha123", password_confirmation: "Senha123", role: :admin)
  end
  let!(:admin) { Admin.create!(usuario: admin_usuario, departamento: departamento) }
  let!(:criador) { CriadorFormulario.create!(usuario: admin_usuario) }
  let(:materia) { Materia.create!(codigoMateria: "DEP01", nome_materia: "Depto Materia", departamento: departamento) }
  let(:prof_u) do
    Usuario.create!(nome: "Prof Depto", email: "prof-depto@example.com",
      password: "Senha123", password_confirmation: "Senha123", role: :professor)
  end
  let(:professor) { Professor.create!(usuario: prof_u) }
  let(:turma) { Turma.create!(numero_turma: 1, semestre_string: "2026/1", materia: materia, professor: professor) }
  let(:template) { TemplateFormulario.create!(nome_template: "T Depto", criador_formulario: criador) }
  let(:formulario) { Formulario.create!(nome_formulario: "Form Depto", turma: turma, criador_formulario: criador, template_formulario: template) }

  def login_as(usuario)
    post login_path, params: { email: usuario.email, password: "Senha123" }
  end

  describe "Admin visualiza turmas do seu departamento" do
    it "retorna ok com as turmas listadas" do
      turma
      login_as(admin_usuario)
      get departamento_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Depto Materia")
    end
  end

  describe "Admin associa formulário a uma turma do departamento" do
    it "redireciona com mensagem de sucesso" do
      turma
      formulario
      login_as(admin_usuario)

      post turma_formularios_path, params: { turma_id: turma.id, formulario_id: formulario.id }

      expect(response).to redirect_to(departamento_turma_path(turma))
      follow_redirect!
      expect(response.body).to include("associado com sucesso")
    end
  end

  describe "Admin tenta acessar turma de outro departamento" do
    it "redireciona com mensagem de erro" do
      other_depto = Departamento.create!(nome_departamento: "Outro Depto")
      other_mat = Materia.create!(codigoMateria: "OUT01", nome_materia: "Outra", departamento: other_depto)
      other_turma = Turma.create!(numero_turma: 9, semestre_string: "2026/1", materia: other_mat, professor: professor)

      login_as(admin_usuario)

      get departamento_turma_path(other_turma)

      expect(response).to redirect_to(departamento_path)
      follow_redirect!
      expect(response.body).to include("não pertence ao seu departamento")
    end
  end

  describe "Usuário sem perfil de admin não acessa departamento" do
    it "redireciona para root" do
      login_as(prof_u)
      get departamento_path
      expect(response).to redirect_to(root_path)
    end
  end
end
