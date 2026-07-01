require 'rails_helper'

RSpec.describe "Usuarios", type: :request do
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

  def logar_como(usuario)
    post login_path, params: { login: usuario.email, senha: "Senha123" }
  end

  describe "GET /usuarios (require_login)" do
    context "sem sessão ativa" do
      it "redireciona para a tela de login com alerta" do
        get usuarios_path
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("precisa estar logado")
      end
    end
  end

  describe "GET /usuarios (require_admin)" do
    context "logado como usuário comum" do
      before { logar_como(docente) }

      it "redireciona para a página inicial com alerta de acesso negado" do
        get usuarios_path
        expect(response).to redirect_to(inicio_path)
        follow_redirect!
        expect(response.body).to include("Acesso negado")
      end
    end

    context "logado como Administrador" do
      before { logar_como(admin) }

      it "permite o acesso" do
        get usuarios_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /usuarios/:id" do
    context "sem sessão ativa" do
      it "redireciona para a tela de login" do
        get usuario_path(docente)
        expect(response).to redirect_to(root_path)
      end
    end

    context "logado como usuário comum" do
      before { logar_como(docente) }

      it "redireciona para a página inicial" do
        get usuario_path(docente)
        expect(response).to redirect_to(inicio_path)
      end
    end

    context "logado como Administrador" do
      before { logar_como(admin) }

      it "permite o acesso" do
        get usuario_path(docente)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "DELETE /usuarios/:id" do
    context "sem sessão ativa" do
      it "redireciona para a tela de login" do
        delete usuario_path(docente)
        expect(response).to redirect_to(root_path)
      end
    end

    context "logado como usuário comum" do
      before { logar_como(docente) }

      it "redireciona para a página inicial" do
        delete usuario_path(docente)
        expect(response).to redirect_to(inicio_path)
      end
    end

    context "logado como Administrador" do
      before { logar_como(admin) }

      it "remove o usuário e redireciona para a listagem" do
        delete usuario_path(docente)
        expect(response).to redirect_to(usuarios_path)
      end
    end
  end

  describe "Ações CRUD Adicionais" do
    before { logar_como(admin) }

    it "acessa a página de new" do
      get new_usuario_path
      expect(response).to have_http_status(:ok)
    end

    it "acessa a página de edit" do
      get edit_usuario_path(docente)
      expect(response).to have_http_status(:ok)
    end

    it "cria um novo usuário com sucesso (happy path)" do
      expect {
        post usuarios_path, params: {
          usuario: {
            matricula: "novo123",
            email: "novo@unb.br",
            nome: "Novo Teste",
            type: "Docente",
            senha: "Senha123",
            senha_confirmation: "Senha123",
            formacao: "Mestrado"
          }
        }
      }.to change(Usuario, :count).by(1)
      expect(response).to redirect_to(docente_url(Usuario.last)).or redirect_to(usuario_url(Usuario.last))
    end

    it "falha ao criar usuário com dados inválidos (sad path)" do
      expect {
        post usuarios_path, params: { usuario: { email: "" } } # Email em branco falha
      }.to change(Usuario, :count).by(0)
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "atualiza um usuário com sucesso (happy path)" do
      patch usuario_path(docente), params: { usuario: { nome: "Nome Atualizado" } }
      docente.reload
      expect(docente.nome).to eq("Nome Atualizado")
      expect(response).to redirect_to(docente_url(docente)).or redirect_to(usuario_url(docente))
    end

    it "falha ao atualizar usuário com dados inválidos (sad path)" do
      patch usuario_path(docente), params: { usuario: { email: "" } } # Email em branco falha
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "Avaliações e Respostas" do
    let(:disciplina) { Disciplina.find_or_create_by!(nome: "Software", codigo: "SW1", departamento: departamento) }
    let(:turma) { Turma.find_or_create_by!(numero_da_turma: "TA", disciplina: disciplina, semestre: "2026.1") }
    let(:formulario) { Formulario.create!(turma: turma) }

    let!(:elemento) { formulario.elemento_forms.create!(enunciado: "Avalie o professor", ordem: 1, tipo: "Texto") }
    let!(:campo) { elemento.campo_forms.create!(enunciado: "Resposta", ordem: 1) }

    let(:curso) { Curso.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC", departamento: departamento) }

    let(:discente) do
      Discente.create!(
        nome: "Aluno Teste",
        matricula: "disc001",
        email: "aluno@unb.br",
        curso: curso,
        senha: "Senha123",
        senha_confirmation: "Senha123"
      )
    end

    before do
      turma.docentes << docente
      turma.discentes << discente
    end

    context "GET /usuarios/:usuario_id/avaliacoes" do
      it "lista avaliações para um docente" do
        logar_como(docente)
        get usuarios_avaliacoes_path(docente)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(formulario.id.to_s).or include(turma.disciplina.nome)
      end

      it "lista avaliações para um discente" do
        logar_como(discente)
        get usuarios_avaliacoes_path(discente)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(formulario.id.to_s).or include(turma.disciplina.nome)
      end

      it "retorna lista vazia para administrador (não possui turmas diretas no model atual)" do
        logar_como(admin)
        get usuarios_avaliacoes_path(admin)
        expect(response).to have_http_status(:ok)
        expect(response.body).not_to include(turma.disciplina.nome)
      end
    end

    context "GET /usuarios/:usuario_id/formularios/:formulario_id/responder" do
      before { logar_como(discente) }

      it "acessa a página de resposta do formulário" do
        get usuarios_responder_formulario_path(usuario_id: discente.id, formulario_id: formulario.id)
        expect(response).to have_http_status(:ok)
      end

      it "redireciona com alerta se o formulário já foi respondido" do
        RespostaForm.create!(formulario: formulario, usuario: discente, data_submissao: Date.today)
        get usuarios_responder_formulario_path(usuario_id: discente.id, formulario_id: formulario.id)

        expect(response).to redirect_to(usuarios_avaliacoes_path(discente))
        expect(flash[:notice]).to eq("Você já respondeu este formulário.")
      end
    end

    context "POST /usuarios/:usuario_id/formularios/:formulario_id/responder (submeter_resposta)" do
      before { logar_como(discente) }

      it "submete respostas com sucesso (happy path)" do
        expect {
          post usuarios_submeter_resposta_path(usuario_id: discente.id, formulario_id: formulario.id),
               params: { respostas: { elemento.id.to_s => "O professor foi ótimo" } }
        }.to change(RespostaForm, :count).by(1).and change(RespostaElem, :count).by(1)

        expect(response).to redirect_to(usuarios_avaliacoes_path(discente))
        expect(flash[:notice]).to eq("Respostas enviadas com sucesso!")
      end

      it "falha ao submeter deixando uma resposta em branco (sad path)" do
        expect {
          post usuarios_submeter_resposta_path(usuario_id: discente.id, formulario_id: formulario.id),
               params: { respostas: { elemento.id.to_s => "" } }
        }.to change(RespostaForm, :count).by(0)

        expect(response).to have_http_status(:unprocessable_content)
        expect(flash.now[:alert]).to eq("Por favor, responda todas as perguntas obrigatórias")
      end

      it "redireciona se tentar submeter um formulário já respondido" do
        RespostaForm.create!(formulario: formulario, usuario: discente, data_submissao: Date.today)

        post usuarios_submeter_resposta_path(usuario_id: discente.id, formulario_id: formulario.id),
             params: { respostas: { elemento.id.to_s => "O professor foi ótimo" } }

        expect(response).to redirect_to(usuarios_avaliacoes_path(discente))
        expect(flash[:alert]).to eq("Você já respondeu este formulário.")
      end
    end
  end
end
