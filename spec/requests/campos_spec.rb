require 'rails_helper'

RSpec.describe "Campos", type: :request do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let!(:admin) do
    Administrador.create!(
      nome: "Admin Campo",
      matricula: "adm_campo2",
      email: "adm_campo2@unb.br",
      senha: "Senha123",
      senha_confirmation: "Senha123",
      departamento: departamento
    )
  end
  let(:template) do
    t = admin.templates.build(nome: "Template Campo")
    t.save(validate: false)
    t
  end
  let(:elemento) { Elemento.create!(enunciado: "Q1", ordem: 1, template: template) }
  let!(:campo) { Campo.create!(ordem: 1, tipo_elemento: "Multipla Escolha", enunciado: "Opção A", elemento: elemento) }

  before { post login_path, params: { login: admin.email, senha: "Senha123" } }

  describe "GET /campos" do
    it "sem sessão ativa redireciona para login" do
      delete logout_path
      get campos_path
      expect(response).to redirect_to(root_path)
    end

    it "retorna 200 OK" do
      get campos_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /campos/new" do
    it "retorna 200 OK" do
      get new_campo_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /campos" do
    it "cria campo com sucesso (happy path)" do
      expect {
        post campos_path, params: {
          campo: { ordem: 99, tipo_elemento: "Texto", enunciado: "Novo campo", elemento_id: elemento.id }
        }
      }.to change(Campo, :count).by(1)

      expect(response).to redirect_to(campo_url(Campo.last))
    end

    it "falha ao criar sem tipo_elemento (sad path)" do
      expect {
        post campos_path, params: {
          campo: { ordem: 2, tipo_elemento: "", enunciado: "X", elemento_id: elemento.id }
        }
      }.not_to change(Campo, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "GET /campos/:id" do
    it "retorna 200 OK" do
      get campo_path(campo)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /campos/:id/edit" do
    it "retorna 200 OK" do
      get edit_campo_path(campo)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /campos/:id" do
    it "atualiza com sucesso (happy path)" do
      patch campo_path(campo), params: {
        campo: { ordem: campo.ordem, tipo_elemento: "Texto", enunciado: "Atualizado", elemento_id: elemento.id }
      }
      campo.reload
      expect(campo.enunciado).to eq("Atualizado")
      expect(response).to redirect_to(campo_url(campo))
    end

    it "falha ao atualizar sem tipo_elemento (sad path)" do
      patch campo_path(campo), params: {
        campo: { ordem: 1, tipo_elemento: "", enunciado: "X", elemento_id: elemento.id }
      }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE /campos/:id" do
    it "destrói o campo e redireciona" do
      c = Campo.create!(ordem: 50, tipo_elemento: "Texto", elemento: elemento)
      expect {
        delete campo_path(c)
      }.to change(Campo, :count).by(-1)

      expect(response).to redirect_to(campos_url)
    end
  end
end
