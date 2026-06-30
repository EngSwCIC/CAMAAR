require 'rails_helper'

RSpec.describe "Avaliacoes", type: :request do
  # Setup compartilhado -------------------------------------------------
  let(:departamento) { Departamento.create!(nome: "DCC") }
  let(:disciplina)   { Disciplina.create!(codigo: "CIC001", nome: "Eng. Software") }
  let(:admin) do
    Usuario.create!(nome: "Admin", email: "admin@unb.br",
                    perfil: "administrador", password: "senha", ativo: true)
  end
  let(:docente) do
    Usuario.create!(nome: "Prof", email: "prof@unb.br",
                    perfil: "docente", password: "senha", ativo: true)
  end
  let(:discente) do
    Usuario.create!(nome: "Aluno", email: "aluno@unb.br",
                    perfil: "discente", password: "senha", ativo: true)
  end
  let(:turma) do
    Turma.create!(codigo_turma: "T1", semestre: "2024.1",
                  disciplina: disciplina, departamento: departamento,
                  docente: docente)
  end
  let(:template) do
    Template.create!(titulo: "T", criador: admin, skip_questions_validation: true)
  end
  let!(:matricula) { Matricula.create!(usuario: discente, turma: turma, papel_na_turma: "aluno") }
  let!(:questao) do
    QuestaoTemplate.create!(template: template, enunciado: "Q?",
                             tipo: "texto", obrigatoria: true, ordem: 1)
  end
  let(:formulario) do
    Formulario.create!(
      template: template, turma: turma, criado_por: admin,
      publico_alvo: "discente", status: "aberto",
      data_inicio: 1.day.ago, data_limite: 1.day.from_now
    )
  end

  # ── GET /avaliacoes ────────────────────────────────────────────────────

  describe "GET /avaliacoes" do
    context "como administrador" do
      before { post login_path, params: { email: admin.email, password: "senha" } }

      it "renderiza com sucesso e chama load_admin_pesquisas" do
        formulario # força a criação
        get avaliacoes_path
        expect(response).to have_http_status(:success)
        # admin enxerga todos os formulários abertos
        expect(response.body).to include("Eng. Software")
      end
    end

    context "como docente" do
      before { post login_path, params: { email: docente.email, password: "senha" } }

      it "renderiza formulários vinculados às turmas do docente" do
        formulario_doc = Formulario.create!(
          template: template, turma: turma, criado_por: admin,
          publico_alvo: "docente", status: "aberto",
          data_inicio: 1.day.ago, data_limite: 1.day.from_now
        )
        get avaliacoes_path
        expect(response).to have_http_status(:success)
      end

      it "retorna vazio quando o docente não tem turmas com formulários ativos" do
        get avaliacoes_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include("não possui formulários pendentes")
      end
    end

    context "como discente" do
      before { post login_path, params: { email: discente.email, password: "senha" } }

      it "lista formulários pendentes dentro do prazo" do
        formulario
        get avaliacoes_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Eng. Software")
      end

      it "não exibe formulários com data_limite no passado" do
        formulario.update!(data_limite: 1.day.ago)
        get avaliacoes_path
        expect(response.body).not_to include("Eng. Software")
      end

      it "não exibe formulários já respondidos como pendentes" do
        Resposta.create!(formulario: formulario, usuario: discente, enviado_em: Time.current)
        get avaliacoes_path
        # deve aparecer na seção de respondidos, não na de pendentes
        expect(response.body).to include("Respondido")
      end

      it "exibe mensagem quando não há formulários" do
        get avaliacoes_path
        expect(response.body).to include("não possui formulários pendentes")
      end
    end

    context "sem autenticação" do
      it "redireciona para login" do
        get avaliacoes_path
        expect(response).to redirect_to(login_path)
      end
    end
  end

  # ── GET /avaliacoes/:id/responder ──────────────────────────────────────

  describe "GET /avaliacoes/:id/responder" do
    before { post login_path, params: { email: discente.email, password: "senha" } }

    it "renderiza o formulário de resposta" do
      get responder_avaliacao_path(formulario)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Q?")
    end
  end

  # ── POST /avaliacoes/:id/responder ─────────────────────────────────────

  describe "POST /avaliacoes/:id/responder" do
    before { post login_path, params: { email: discente.email, password: "senha" } }

    it "falha se campo obrigatório estiver vazio" do
      post responder_avaliacao_path(id: formulario.id),
           params: { respostas: { "0" => { texto: "" } } }
      expect(response).to redirect_to(responder_avaliacao_path(formulario))
      follow_redirect!
      expect(response.body).to include("Preencha todos os campos obrigatórios")
    end

    it "cria resposta com dados válidos" do
      post responder_avaliacao_path(id: formulario.id),
           params: { respostas: { "0" => { texto: "Excelente!" } } }
      expect(response).to redirect_to(avaliacoes_path)
      expect(Resposta.count).to eq(1)
    end

    it "impede dupla submissão" do
      Resposta.create!(formulario: formulario, usuario: discente, enviado_em: Time.current)
      post responder_avaliacao_path(id: formulario.id),
           params: { respostas: { "0" => { texto: "segunda tentativa" } } }
      follow_redirect!
      expect(response.body).to include("Você já respondeu a este formulário")
      expect(Resposta.count).to eq(1)
    end

    context "com questão likert" do
      let!(:questao_likert) do
        QuestaoTemplate.create!(template: template, enunciado: "Nota?",
                                tipo: "likert", obrigatoria: true, ordem: 2)
      end
      let(:formulario_likert) do
        Formulario.create!(
          template: template, turma: turma, criado_por: admin,
          publico_alvo: "discente", status: "aberto",
          data_inicio: 1.day.ago, data_limite: 1.day.from_now
        )
      end

      it "falha se nota likert estiver em branco" do
        post responder_avaliacao_path(id: formulario_likert.id),
             params: { respostas: { "0" => { texto: "ok" }, "1" => { nota: "" } } }
        follow_redirect!
        expect(response.body).to include("Preencha todos os campos obrigatórios")
      end

      it "cria resposta com nota likert" do
        post responder_avaliacao_path(id: formulario_likert.id),
             params: { respostas: { "0" => { texto: "ok" }, "1" => { nota: "4" } } }
        expect(response).to redirect_to(avaliacoes_path)
        expect(RespostaItem.where(valor_numerico: 4).count).to eq(1)
      end
    end
  end
end
