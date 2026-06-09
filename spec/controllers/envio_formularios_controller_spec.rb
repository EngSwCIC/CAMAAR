# spec/controllers/envio_formularios_controller_spec.rb
require "rails_helper"

RSpec.describe EnvioFormulariosController, type: :controller do
  let(:depto)      { create(:departamento) }
  let(:usr_doc)    { create(:usuario, perfil: :docente) }
  let(:docente)    { create(:docente, usuario: usr_doc, departamento: depto) }
  let(:disciplina) { create(:disciplina) }
  let(:turma)      { create(:turma, disciplina: disciplina, docente: docente) }
  let(:template)   { create(:template, docente: docente) }

  let(:usr_disc)   { create(:usuario, perfil: :discente, primeiro_acesso: false) }
  let(:discente)   { create(:discente, usuario: usr_disc) }

  let(:qt_aberta)  { create(:questao_template, template: template, tipo: :aberta) }
  let(:qt_multi)   { create(:questao_template, template: template, tipo: :multipla) }
  let!(:opcao1)    { create(:opcao_questao, questao_template: qt_multi, texto: "Ótimo") }
  let!(:opcao2)    { create(:opcao_questao, questao_template: qt_multi, texto: "Bom") }

  let!(:formulario) { create(:formulario, turma: turma, template: template, prazo: 7.days.from_now) }
  let!(:q1) { create(:questao, formulario: formulario, questao_template: qt_aberta, tipo: :aberta) }
  let!(:q2) { create(:questao, formulario: formulario, questao_template: qt_multi,  tipo: :multipla) }

  before do
    session[:usuario_id] = usr_disc.id
    create(:matricula, discente: discente, turma: turma)
  end

  # ── GET #new ──────────────────────────────────────────────────────────────
  describe "GET #new" do
    it "retorna 200 para discente matriculado com formulário aberto" do
      get :new, params: { formulario_id: formulario.id }
      expect(response).to have_http_status(:ok)
    end

    it "atribui o formulário correto" do
      get :new, params: { formulario_id: formulario.id }
      expect(assigns(:formulario)).to eq(formulario)
    end

    it "lista as questões do formulário" do
      get :new, params: { formulario_id: formulario.id }
      expect(assigns(:questoes)).to match_array([q1, q2])
    end

    context "discente já respondeu" do
      before { create(:envio_formulario, formulario: formulario, discente: discente) }

      it "redireciona para minha_resposta" do
        get :new, params: { formulario_id: formulario.id }
        expect(response).to redirect_to(minha_resposta_formulario_path(formulario))
      end
    end

    context "formulário com prazo encerrado" do
      before { formulario.update!(prazo: 1.day.ago) }

      it "redireciona para formularios_path com alerta de prazo" do
        get :new, params: { formulario_id: formulario.id }
        expect(response).to redirect_to(formularios_path)
        expect(flash[:alert]).to match(/prazo/i)
      end
    end

    context "discente não matriculado na turma" do
      before { discente.matriculas.destroy_all }

      it "redireciona com alerta de acesso" do
        get :new, params: { formulario_id: formulario.id }
        expect(response).to redirect_to(formularios_path)
        expect(flash[:alert]).to be_present
      end
    end

    context "sem autenticação" do
      before { session[:usuario_id] = nil }

      it "redireciona para login" do
        get :new, params: { formulario_id: formulario.id }
        expect(response).to redirect_to(login_path)
      end
    end

    context "logado como docente" do
      before { session[:usuario_id] = usr_doc.id }

      it "redireciona para root" do
        get :new, params: { formulario_id: formulario.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # ── POST #create ──────────────────────────────────────────────────────────
  describe "POST #create" do
    let(:respostas_validas) do
      { q1.id.to_s => "Ótima disciplina!", q2.id.to_s => "Ótimo" }
    end

    it "cria EnvioFormulario com respostas completas" do
      expect {
        post :create, params: { formulario_id: formulario.id, respostas: respostas_validas }
      }.to change(EnvioFormulario, :count).by(1)
        .and change(Resposta, :count).by(2)
    end

    it "redireciona para dashboard com mensagem de sucesso" do
      post :create, params: { formulario_id: formulario.id, respostas: respostas_validas }
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to match(/sucesso/i)
    end

    it "registra enviado_em" do
      post :create, params: { formulario_id: formulario.id, respostas: respostas_validas }
      envio = EnvioFormulario.last
      expect(envio.enviado_em).not_to be_nil
    end

    it "salva o conteúdo correto em cada Resposta" do
      post :create, params: { formulario_id: formulario.id, respostas: respostas_validas }
      envio = EnvioFormulario.find_by(formulario: formulario, discente: discente)
      expect(envio.respostas.find_by(questao: q1).conteudo).to eq("Ótima disciplina!")
      expect(envio.respostas.find_by(questao: q2).conteudo).to eq("Ótimo")
    end

    context "resposta faltando em uma questão" do
      it "não cria envio e renderiza :new" do
        expect {
          post :create, params: {
            formulario_id: formulario.id,
            respostas: { q1.id.to_s => "Comentário", q2.id.to_s => "" }
          }
        }.not_to change(EnvioFormulario, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash[:alert]).to match(/obrigatórias/i)
      end
    end

    context "tentativa de envio duplicado" do
      before { create(:envio_formulario, formulario: formulario, discente: discente) }

      it "redireciona para minha_resposta sem criar novo envio" do
        expect {
          post :create, params: { formulario_id: formulario.id, respostas: respostas_validas }
        }.not_to change(EnvioFormulario, :count)

        expect(response).to redirect_to(minha_resposta_formulario_path(formulario))
      end
    end

    context "formulário encerrado" do
      before { formulario.update!(prazo: 1.day.ago) }

      it "redireciona para formularios_path sem criar envio" do
        expect {
          post :create, params: { formulario_id: formulario.id, respostas: respostas_validas }
        }.not_to change(EnvioFormulario, :count)

        expect(response).to redirect_to(formularios_path)
      end
    end

    context "discente de outra turma" do
      before { discente.matriculas.destroy_all }

      it "redireciona com alerta de acesso" do
        post :create, params: { formulario_id: formulario.id, respostas: respostas_validas }
        expect(response).to redirect_to(formularios_path)
        expect(flash[:alert]).to be_present
      end
    end
  end
end
