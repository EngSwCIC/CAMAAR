require 'rails_helper'

RSpec.describe "Formularios", type: :request do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let(:disciplina) { Disciplina.find_or_create_by!(nome: "Engenharia de Software", codigo: "CIC0097", departamento: departamento) }
  let(:turma) { Turma.find_or_create_by!(numero_da_turma: "TA", disciplina: disciplina, semestre: "2026.1") }

  let(:curso) { Curso.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC", departamento: departamento) }

  let(:admin) do
    Administrador.create!(
      nome: "Admin", matricula: "123", email: "admin@unb.br",
      senha: "Senha123", senha_confirmation: "Senha123", departamento: departamento
    )
  end

  let(:discente) do
    Discente.create!(
      nome: "Aluno Teste", matricula: "241000", email: "aluno@unb.br",
      curso: curso, # 2. Recebendo a variável em vez da string!
      senha: "Senha123", senha_confirmation: "Senha123"
    )
  end

  describe "Criar formulário (Admin)" do
    before { post login_path, params: { login: admin.email, senha: "Senha123" } }

    it "cria um formulário vinculando à turma" do
      expect {
        post formularios_path, params: {
          formulario: {
            turma_id: turma.id
          }
        }
      }.to change(Formulario, :count).by(1)

      expect(response).to be_redirect
    end
  end

  describe "Visualizar formulários (Participante)" do
    let!(:formulario) do
      Formulario.create!(turma: turma)
    end

    before do
      post login_path, params: { login: discente.email, senha: "Senha123" }
    end

    it "lista os formulários disponíveis para o aluno" do
      get formularios_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "Ações CRUD complementares" do
    let!(:outra_turma) { Turma.find_or_create_by!(numero_da_turma: "TB", disciplina: disciplina, semestre: "2026.1") }
    let!(:formulario) { Formulario.create!(turma: turma) }

    before do
      post login_path, params: { login: admin.email, senha: "Senha123" }
    end

    it "acessa a página de show" do
      get formulario_path(formulario)
      expect(response).to have_http_status(:ok)
    end

    it "acessa a página de new" do
      get new_formulario_path
      expect(response).to have_http_status(:ok)
    end

    it "acessa a página de edit" do
      get edit_formulario_path(formulario)
      expect(response).to have_http_status(:ok)
    end

    it "falha ao criar um formulário inválido (sad path)" do
      expect {
        post formularios_path, params: { formulario: { turma_id: nil } }
      }.to change(Formulario, :count).by(0)

      expect(response).to have_http_status(:unprocessable_content)
    end

    it "atualiza um formulário existente com sucesso (happy path)" do
      patch formulario_path(formulario), params: { formulario: { turma_id: outra_turma.id } }
      formulario.reload

      expect(formulario.turma_id).to eq(outra_turma.id)
      expect(response).to redirect_to(formulario_url(formulario))
    end

    it "falha ao atualizar com dados inválidos (sad path)" do
      patch formulario_path(formulario), params: { formulario: { turma_id: nil } }

      expect(response).to have_http_status(:unprocessable_content)
    end

    it "deleta um formulário com sucesso" do
      expect {
        delete formulario_path(formulario)
      }.to change(Formulario, :count).by(-1)

      expect(response).to redirect_to(formularios_url)
    end
  end
end
