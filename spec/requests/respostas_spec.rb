require "rails_helper"

RSpec.describe "Responder Formulário", type: :request do
  let(:departamento) { Departamento.create!(nome_departamento: "CIC Resp") }
  let(:admin_u) do
    Usuario.create!(nome: "Admin Resp", email: "admin-respospec@example.com",
      password: "Senha123", password_confirmation: "Senha123", role: :admin)
  end
  let!(:criador) { CriadorFormulario.create!(usuario: admin_u) }
  let(:materia) { Materia.create!(codigoMateria: "RESP01", nome_materia: "Resp Materia", departamento: departamento) }
  let(:prof_u) do
    Usuario.create!(nome: "Prof Resp", email: "prof-respospec@example.com",
      password: "Senha123", password_confirmation: "Senha123", role: :professor)
  end
  let(:professor) { Professor.create!(usuario: prof_u) }
  let(:turma) { Turma.create!(numero_turma: 1, semestre_string: "2026/1", materia: materia, professor: professor) }
  let(:template) { TemplateFormulario.create!(nome_template: "T Resp", criador_formulario: criador) }
  let(:formulario) { Formulario.create!(nome_formulario: "Form Resposta", turma: turma, criador_formulario: criador, template_formulario: template, publico_estudante: true) }
  let(:student_u) do
    Usuario.create!(nome: "Aluno Resp", email: "aluno-respospec@example.com",
      password: "Senha123", password_confirmation: "Senha123", role: :estudante)
  end
  let!(:estudante) { Estudante.create!(usuario: student_u) }
  let!(:matricula) { Matricula.create!(estudante: estudante, turma: turma, trancado: false) }

  def login_as(usuario)
    post login_path, params: { email: usuario.email, password: "Senha123" }
  end

  describe "Estudante responde formulário com sucesso" do
    it "registra resposta e redireciona com confirmação" do
      login_as(student_u)

      expect {
        post formulario_respostas_path(formulario), params: { respostas: {} }
      }.to change(RespostaFormulario, :count).by(1)

      expect(response).to redirect_to(avaliacoes_path)
      follow_redirect!
      expect(response.body).to include("registrada")
    end
  end

  describe "Estudante tenta responder sem preencher questões obrigatórias" do
    it "não registra quando há perguntas não respondidas" do
      pergunta = Pergunta.create!(enunciado: "P?", tipo_pergunta: :discursiva, gabarito_discursiva: "R", template_formulario: template)
      pf = PerguntaFormulario.create!(formulario: formulario, pergunta: pergunta, enunciado: "P?", tipo_pergunta: :discursiva)
      login_as(student_u)

      expect {
        post formulario_respostas_path(formulario), params: { respostas: { pf.id.to_s => "" } }
      }.not_to change(RespostaFormulario, :count)

      expect(response.body).to include("obrigatóri")
    end
  end

  describe "Estudante não matriculado não pode responder" do
    let(:other_u) do
      Usuario.create!(nome: "Outro Aluno", email: "outro-respospec@example.com",
        password: "Senha123", password_confirmation: "Senha123", role: :estudante)
    end
    let!(:outro_est) { Estudante.create!(usuario: other_u) }

    it "nega acesso e redireciona" do
      login_as(other_u)

      expect {
        post formulario_respostas_path(formulario), params: { respostas: {} }
      }.not_to change(RespostaFormulario, :count)

      expect(response).to redirect_to(avaliacoes_path)
      follow_redirect!
      expect(response.body).to include("permissão")
    end
  end

  describe "Formulário não público bloqueia acesso do estudante" do
    let(:form_privado) { Formulario.create!(nome_formulario: "Form Privado Resp", turma: turma, criador_formulario: criador, template_formulario: template, publico_estudante: false) }

    it "redireciona com mensagem de permissão" do
      login_as(student_u)
      get formulario_path(form_privado)
      expect(response).to redirect_to(avaliacoes_path)
      follow_redirect!
      expect(response.body).to include("permissão")
    end
  end

  describe "Formulário inexistente não é respondido" do
    it "redireciona com mensagem de formulário não encontrado" do
      login_as(student_u)
      post "/formularios/99999999/respostas", params: { respostas: {} }
      expect(response).to redirect_to(avaliacoes_path)
      follow_redirect!
      expect(response.body).to include("não encontrado")
    end
  end

  describe "Usuário sem perfil de estudante tenta responder" do
    it "redireciona com mensagem de permissão negada" do
      login_as(admin_u)
      post formulario_respostas_path(formulario), params: { respostas: {} }
      expect(response).to redirect_to(avaliacoes_path)
      follow_redirect!
      expect(response.body).to include("permissão")
    end
  end

  describe "Estudante tenta responder formulário já respondido" do
    it "redireciona com mensagem de formulário já respondido" do
      RespostaFormulario.create!(formulario: formulario, usuario: student_u)
      login_as(student_u)
      post formulario_respostas_path(formulario), params: { respostas: {} }
      expect(response).to redirect_to(avaliacoes_path)
      follow_redirect!
      expect(response.body).to include("já respondeu")
    end
  end

  describe "Erro interno ao salvar resposta" do
    it "reexibe o formulário com mensagem de erro quando save falha" do
      allow_any_instance_of(RespostaFormulario).to receive(:save).and_return(false)
      login_as(student_u)
      post formulario_respostas_path(formulario), params: { respostas: {} }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Erro ao registrar resposta")
    end
  end
end
