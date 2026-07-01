require 'rails_helper'

RSpec.describe "Importação SIGAA", type: :request do
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

  before do
    post login_path, params: { login: admin.email, senha: "Senha123" }
  end

  describe "POST /admin/:admin_id/sincronizar_sigaa" do
    it "importa usuários do JSON com sucesso" do
      json_file = fixture_file_upload(Rails.root.join('class_members.json'), 'application/json')

      post admin_sincronizar_sigaa_path(admin_id: admin.id), params: {
        acao: "importar",
        arquivo_classes: json_file,
        arquivo_membros: json_file
      }

      expect(response).to redirect_to(admin_gerenciamento_path(admin))
    end
  end
end
