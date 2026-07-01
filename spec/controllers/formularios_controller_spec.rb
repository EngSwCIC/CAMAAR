# spec/controllers/formularios_controller_spec.rb
require "rails_helper"

RSpec.describe FormulariosController, type: :controller do
  let(:depto)      { create(:departamento) }
  let(:disciplina) { create(:disciplina) }

  let(:usr_doc)    { create(:usuario, perfil: :docente) }
  let(:docente)    { create(:docente, usuario: usr_doc, departamento: depto) }
  let(:turma)      { create(:turma, disciplina: disciplina, docente: docente) }
  let(:template)   { create(:template, docente: docente) }

  let(:usr_disc)   { create(:usuario, perfil: :discente, primeiro_acesso: false) }
  let(:discente)   { create(:discente, usuario: usr_disc) }
  let(:user_disc)  { create(:user, perfil: "Discente", email: usr_disc.email, primeiro_acesso: false) }

  before do
    session[:user_id] = user_disc.id
    create(:matricula, discente: discente, turma: turma)
  end

  # ── GET #index ───────────────────────────────────────────────────────
  describe "GET #index" do
    let!(:pendente)   { create(:formulario, turma: turma, template: template, prazo: 7.days.from_now) }
    let!(:respondido) do
      f = create(:formulario, turma: turma, template: template, prazo: 7.days.from_now)
      create(:envio_formulario, formulario: f, discente: discente)
      f
    end
    let!(:fechado) { create(:formulario, turma: turma, template: template, prazo: 1.day.ago) }

    it "responde com 200" do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it "separa corretamente pendentes, respondidos e fechados" do
      get :index
      expect(assigns(:formularios_pendentes)).to   include(pendente)
      expect(assigns(:formularios_respondidos)).to include(respondido)
      expect(assigns(:formularios_fechados)).to    include(fechado)
    end

    it "formulário respondido não aparece nos pendentes" do
      get :index
      expect(assigns(:formularios_pendentes)).not_to include(respondido)
    end

    it "não mostra formulários de turmas sem matrícula" do
      outra_turma = create(:turma, disciplina: disciplina, docente: docente)
      outro_form  = create(:formulario, turma: outra_turma, template: template)
      get :index
      todos = assigns(:formularios_pendentes).to_a +
              assigns(:formularios_respondidos).to_a +
              assigns(:formularios_fechados).to_a
      expect(todos).not_to include(outro_form)
    end

    context "sem autenticação" do
      before { session[:user_id] = nil }

      it "redireciona para root" do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end

    context "logado como docente" do
      let(:user_doc) { create(:user, perfil: "Docente", email: usr_doc.email) }
      before { session[:user_id] = user_doc.id }

      it "redireciona para root" do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # ── GET #show ────────────────────────────────────────────────────────
  describe "GET #show" do
    let!(:formulario) { create(:formulario, turma: turma, template: template, prazo: 7.days.from_now) }

    it "responde com 200 para discente matriculado" do
      get :show, params: { id: formulario.id }
      expect(response).to have_http_status(:ok)
    end

    context "formulário fechado" do
      let!(:fechado) { create(:formulario, turma: turma, template: template, prazo: 1.day.ago) }

      it "redireciona para index com alerta de prazo" do
        get :show, params: { id: fechado.id }
        expect(response).to redirect_to(formularios_path)
        expect(flash[:alert]).to match(/prazo/i)
      end
    end

    context "discente já respondeu" do
      before { create(:envio_formulario, formulario: formulario, discente: discente) }

      it "redireciona para minha_resposta" do
        get :show, params: { id: formulario.id }
        expect(response).to redirect_to(minha_resposta_formulario_path(formulario))
      end
    end

    context "discente não está na turma" do
      let(:outra_turma) { create(:turma, disciplina: disciplina, docente: docente) }
      let!(:outro_form) { create(:formulario, turma: outra_turma, template: template) }

      it "redireciona com alerta de acesso" do
        get :show, params: { id: outro_form.id }
        expect(response).to redirect_to(formularios_path)
        expect(flash[:alert]).to be_present
      end
    end

    context "formulário inexistente" do
      it "redireciona com alerta" do
        get :show, params: { id: 0 }
        expect(response).to redirect_to(formularios_path)
      end
    end
  end

  # ── GET #minha_resposta ──────────────────────────────────────────────
  describe "GET #minha_resposta" do
    let!(:formulario) { create(:formulario, turma: turma, template: template) }

    context "discente respondeu" do
      let!(:envio) { create(:envio_formulario, formulario: formulario, discente: discente) }

      it "responde com 200" do
        get :minha_resposta, params: { id: formulario.id }
        expect(response).to have_http_status(:ok)
      end

      it "atribui o envio correto" do
        get :minha_resposta, params: { id: formulario.id }
        expect(assigns(:envio)).to eq(envio)
      end
    end

    context "discente não respondeu" do
      it "redireciona com alerta" do
        get :minha_resposta, params: { id: formulario.id }
        expect(response).to redirect_to(formularios_path)
        expect(flash[:alert]).to be_present
      end
    end
  end
end
