# spec/controllers/envio_formularios_controller_spec.rb
require "rails_helper"

RSpec.describe EnvioFormulariosController, type: :controller do
  let(:depto)     { create(:departamento) }
  let(:disciplina) { create(:disciplina) }
  let(:usr_doc)   { create(:usuario, perfil: :docente) }
  let(:docente)   { create(:docente, usuario: usr_doc, departamento: depto) }
  let(:turma)     { create(:turma, disciplina: disciplina, docente: docente) }
  let(:template)  { create(:template, docente: docente) }
  let(:q_tpl)     { create(:questao_template, template: template) }

  let(:usr_disc)  { create(:usuario, perfil: :discente, primeiro_acesso: false) }
  let(:discente)  { create(:discente, usuario: usr_disc) }
  let(:user_disc) { create(:user, perfil: "Discente", email: usr_disc.email, primeiro_acesso: false) }

  let(:formulario) { create(:formulario, turma: turma, template: template, prazo: 7.days.from_now) }
  let!(:questao)   { create(:questao, formulario: formulario, questao_template: q_tpl) }

  before do
    session[:user_id] = user_disc.id
    create(:matricula, discente: discente, turma: turma)
  end

  # ── Autenticação (before_action :exigir_discente!) ──────────────────────
  describe "autenticação" do
    context "sem sessão ativa" do
      before { session[:user_id] = nil }

      it "redireciona para root no GET #new" do
        get :new, params: { formulario_id: formulario.id }
        expect(response).to redirect_to(root_path)
      end

      it "redireciona para root no POST #create" do
        post :create, params: { formulario_id: formulario.id }
        expect(response).to redirect_to(root_path)
      end
    end

    context "logado como docente" do
      let(:user_doc_auth) { create(:user, perfil: "Docente", email: usr_doc.email) }
      before { session[:user_id] = user_doc_auth.id }

      it "redireciona para root" do
        get :new, params: { formulario_id: formulario.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # ── before_action :set_formulario ───────────────────────────────────────
  describe "before_action :set_formulario" do
    context "formulario_id inexistente" do
      it "redireciona para formularios_path com alerta de não encontrado" do
        get :new, params: { formulario_id: 0 }
        expect(response).to redirect_to(formularios_path)
        expect(flash[:alert]).to match(/não encontrado/i)
      end
    end

    context "formulario_id válido" do
      it "atribui @formulario corretamente" do
        get :new, params: { formulario_id: formulario.id }
        expect(assigns(:formulario)).to eq(formulario)
      end
    end
  end

  # ── GET #new ────────────────────────────────────────────────────────────
  describe "GET #new" do
    context "discente ainda não respondeu" do
      it "responde com 200" do
        get :new, params: { formulario_id: formulario.id }
        expect(response).to have_http_status(:ok)
      end

      it "atribui @questoes com a questão do formulário" do
        get :new, params: { formulario_id: formulario.id }
        expect(assigns(:questoes)).to include(questao)
      end
    end

    context "discente já respondeu" do
      before { allow_any_instance_of(Discente).to receive(:ja_respondeu?).and_return(true) }

      it "redireciona para minha_resposta_formulario com notice" do
        get :new, params: { formulario_id: formulario.id }
        expect(response).to redirect_to(minha_resposta_formulario_path(formulario))
        expect(flash[:notice]).to be_present
      end
    end
  end

  # ── POST #create ────────────────────────────────────────────────────────
  describe "POST #create" do
    context "discente já respondeu" do
      before { allow_any_instance_of(Discente).to receive(:ja_respondeu?).and_return(true) }

      it "redireciona para formularios_path com alerta de duplicação" do
        post :create, params: { formulario_id: formulario.id }
        expect(response).to redirect_to(formularios_path)
        expect(flash[:alert]).to match(/já foi respondido/i)
      end
    end

    context "campos obrigatórios vazios" do
      it "sem parâmetro respostas retorna 422 com alerta" do
        post :create, params: { formulario_id: formulario.id }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to match(/obrigatórios/i)
      end

      it "resposta string vazia retorna 422 com alerta" do
        post :create, params: { formulario_id: formulario.id,
                                respostas: { questao.id.to_s => "" } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to match(/obrigatórios/i)
      end

      it "resposta só com espaços retorna 422 com alerta" do
        post :create, params: { formulario_id: formulario.id,
                                respostas: { questao.id.to_s => "   " } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to match(/obrigatórios/i)
      end

      context "múltiplas questões, uma em branco" do
        let!(:questao2) { create(:questao, formulario: formulario, questao_template: q_tpl) }

        it "retorna 422 quando uma das respostas está em branco" do
          post :create, params: {
            formulario_id: formulario.id,
            respostas: { questao.id.to_s => "3", questao2.id.to_s => "" }
          }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(flash.now[:alert]).to match(/obrigatórios/i)
        end
      end
    end

    context "valor fora do intervalo 1–5" do
      it "valor 0 (abaixo do mínimo) retorna 422 com alerta de range" do
        post :create, params: { formulario_id: formulario.id,
                                respostas: { questao.id.to_s => "0" } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to match(/1 e 5/i)
      end

      it "valor 6 (acima do máximo) retorna 422 com alerta de range" do
        post :create, params: { formulario_id: formulario.id,
                                respostas: { questao.id.to_s => "6" } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to match(/1 e 5/i)
      end
    end

    context "resposta válida" do
      it "valor 1 (fronteira inferior) é aceito e redireciona" do
        post :create, params: { formulario_id: formulario.id,
                                respostas: { questao.id.to_s => "1" } }
        expect(response).to redirect_to(formularios_path)
        expect(flash[:notice]).to be_present
      end

      it "valor 5 (fronteira superior) é aceito e redireciona" do
        post :create, params: { formulario_id: formulario.id,
                                respostas: { questao.id.to_s => "5" } }
        expect(response).to redirect_to(formularios_path)
        expect(flash[:notice]).to be_present
      end

      it "texto não numérico não dispara erro de range" do
        post :create, params: { formulario_id: formulario.id,
                                respostas: { questao.id.to_s => "ótimo" } }
        expect(flash.now[:alert]).not_to match(/1 e 5/i)
      end

      it "redireciona com notice de sucesso" do
        post :create, params: { formulario_id: formulario.id,
                                respostas: { questao.id.to_s => "3" } }
        expect(response).to redirect_to(formularios_path)
        expect(flash[:notice]).to match(/sucesso/i)
      end

      it "cria um EnvioFormulario no banco" do
        expect {
          post :create, params: { formulario_id: formulario.id,
                                  respostas: { questao.id.to_s => "3" } }
        }.to change(EnvioFormulario, :count).by(1)
      end

      it "cria uma Resposta no banco" do
        expect {
          post :create, params: { formulario_id: formulario.id,
                                  respostas: { questao.id.to_s => "3" } }
        }.to change(Resposta, :count).by(1)
      end

      context "com múltiplas questões" do
        let!(:questao2) { create(:questao, formulario: formulario, questao_template: q_tpl) }

        it "cria uma Resposta por questão" do
          expect {
            post :create, params: {
              formulario_id: formulario.id,
              respostas: { questao.id.to_s => "3", questao2.id.to_s => "4" }
            }
          }.to change(Resposta, :count).by(2)
        end
      end
    end

    context "ActiveRecord::RecordInvalid durante o salvamento" do
      before do
        allow_any_instance_of(EnvioFormulario).to receive(:save!).and_raise(
          ActiveRecord::RecordInvalid.new(EnvioFormulario.new)
        )
      end

      it "retorna 422" do
        post :create, params: { formulario_id: formulario.id,
                                respostas: { questao.id.to_s => "3" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "exibe mensagem de erro no flash" do
        post :create, params: { formulario_id: formulario.id,
                                respostas: { questao.id.to_s => "3" } }
        expect(flash.now[:alert]).to be_present
      end

      it "re-atribui @questoes para re-renderizar o formulário" do
        post :create, params: { formulario_id: formulario.id,
                                respostas: { questao.id.to_s => "3" } }
        expect(assigns(:questoes)).to include(questao)
      end
    end
  end
end
