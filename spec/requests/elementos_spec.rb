require 'rails_helper'

RSpec.describe "Elementos", type: :request do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let!(:admin) do
    Administrador.create!(
      nome: "Admin Elem",
      matricula: "adm_elem2",
      email: "adm_elem2@unb.br",
      senha: "Senha123",
      senha_confirmation: "Senha123",
      departamento: departamento
    )
  end
  let(:template) do
    t = admin.templates.build(nome: "Template Elem")
    t.elementos.build(enunciado: "Q Setup", ordem: 1)
    t.save!
    t
  end
  let!(:elemento) { template.elementos.first }

  before { post login_path, params: { login: admin.email, senha: "Senha123" } }

  describe "GET /elementos" do
    it "sem sessão ativa redireciona para login" do
      delete logout_path
      get elementos_path
      expect(response).to redirect_to(root_path)
    end

    it "retorna 200 OK" do
      get elementos_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /elementos/new" do
    it "retorna 200 OK" do
      get new_elemento_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /elementos" do
    it "cria elemento com sucesso (happy path)" do
      expect {
        post elementos_path, params: {
          elemento: { enunciado: "Nova Questão", ordem: 99, template_id: template.id }
        }
      }.to change(Elemento, :count).by(1)

      expect(response).to redirect_to(elemento_url(Elemento.last))
    end

    it "falha ao criar sem template (sad path)" do
      expect {
        post elementos_path, params: {
          elemento: { enunciado: "Questão", ordem: 1, template_id: nil }
        }
      }.not_to change(Elemento, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "GET /elementos/:id" do
    it "retorna 200 OK" do
      get elemento_path(elemento)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /elementos/:id/edit" do
    it "retorna 200 OK" do
      get edit_elemento_path(elemento)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /elementos/:id" do
    it "atualiza com sucesso (happy path)" do
      patch elemento_path(elemento), params: {
        elemento: { enunciado: "Questão Atualizada", ordem: elemento.ordem, template_id: template.id }
      }
      elemento.reload
      expect(elemento.enunciado).to eq("Questão Atualizada")
      expect(response).to redirect_to(elemento_url(elemento))
    end

    it "falha ao atualizar sem template (sad path)" do
      patch elemento_path(elemento), params: {
        elemento: { enunciado: "Q", ordem: 1, template_id: nil }
      }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE /elementos/:id" do
    it "destrói o elemento e redireciona" do
      e = Elemento.create!(enunciado: "Para Deletar", ordem: 50, template: template)
      expect {
        delete elemento_path(e)
      }.to change(Elemento, :count).by(-1)

      expect(response).to redirect_to(elementos_url)
    end
  end
end
