require 'rails_helper'

RSpec.describe "Templates", type: :request do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let(:admin) do
    Administrador.create!(
      nome: "Admin",
      matricula: "123",
      email: "admin@unb.br",
      senha: "Senha123",
      senha_confirmation: "Senha123",
      departamento: departamento
    )
  end
  let!(:template_existente) do
    template = Template.new(nome: "Template Base", administrador: admin)
    template.elementos.build(enunciado: "Questão 1", ordem: 1)
    template.save!
    template
  end

  before do
    post login_path, params: { login: admin.email, senha: "Senha123" }
  end

  describe "GET /templates" do
    it "Feature 6: Visualiza a lista de templates" do
      get admin_templates_path(admin_id: admin.id)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /templates" do
    it "Feature 5: Cria um template com sucesso" do
      expect {
        post admin_templates_path(admin_id: admin.id), params: {
          template: {
            nome: "Avaliação Nova",
            administrador_id: admin.id,
            elementos_attributes: [ { enunciado: "Questão 1", ordem: 1 } ]
          }
        }
      }.to change(Template, :count).by(1)
      expect(response).to be_redirect
    end
  end

  describe "PATCH /templates/:id" do
    it "Feature 7: Edita um template existente" do
      patch admin_template_path(admin_id: admin.id, id: template_existente.id), params: {
        template: { nome: "Nome Atualizado" }
      }
      template_existente.reload
      expect(template_existente.nome).to eq("Nome Atualizado")
    end
  end

  describe "DELETE /templates/:id" do
    it "Feature 7: Deleta um template" do
      expect {
        delete admin_template_path(admin_id: admin.id, id: template_existente.id)
      }.to change(Template, :count).by(-1)
    end
  end
end
