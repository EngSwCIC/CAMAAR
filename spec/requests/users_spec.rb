require 'rails_helper'

RSpec.describe "Users", type: :request do
  include Devise::Test::IntegrationHelpers

  # Criamos o usuário administrador com todos os campos obrigatórios
  let(:admin) { User.create!(email: "admin@unb.br", password: "password123", nome: "Admin", matricula: "000000", perfil: "docente") }

  before do
    sign_in admin
  end

  describe "POST /users/sigaa_import" do
    # Helpers para simular os arquivos sendo anexados no formulário
    let(:classes_upload) do
      file = Tempfile.new(['classes', '.json'])
      file.write("[]") # Simulando um JSON vazio
      file.rewind
      Rack::Test::UploadedFile.new(file.path, 'application/json')
    end

    let(:members_upload) do
      file = Tempfile.new(['members', '.json'])
      file.write("[]")
      file.rewind
      Rack::Test::UploadedFile.new(file.path, 'application/json')
    end

    context "quando o usuário envia os arquivos via formulário (Upload)" do
      it "lê os arquivos anexados, chama o SigaaImporter e redireciona com sucesso" do
        # Fingimos que a importação deu certo e retornou as contagens
        allow(SigaaImporter).to receive(:call).and_return({ turmas: 1, users: 5, enrollments: 5 })

        post "/users/sigaa_import", params: { classes_file: classes_upload, members_file: members_upload }

        expect(response).to redirect_to(users_path)
        expect(flash[:notice]).to match(/SIGAA importado/)
      end
    end

    context "quando o usuário não envia arquivos (Fallback para arquivos do repositório)" do
      it "lê os arquivos locais padrão e redireciona com sucesso" do
        # Fingimos que o File.read leu um JSON válido na pasta do projeto
        allow(File).to receive(:read).and_return("[]")
        allow(SigaaImporter).to receive(:call).and_return({ turmas: 0, users: 0, enrollments: 0 })

        # Requisição sem anexar nada nos params
        post "/users/sigaa_import"

        expect(response).to redirect_to(users_path)
        expect(flash[:notice]).to match(/SIGAA importado/)
      end
    end

    context "quando ocorre um erro durante a importação (Sad Path)" do
      it "cai no rescue, captura a exceção e redireciona com alerta" do
        # O upload é feito, mas forçamos o SigaaImporter a "explodir" com um erro
        allow(SigaaImporter).to receive(:call).and_raise(StandardError.new("Arquivo corrompido"))

        post "/users/sigaa_import", params: { classes_file: classes_upload, members_file: members_upload }

        expect(response).to redirect_to(sigaa_users_path)
        expect(flash[:alert]).to match(/Falha ao importar dados do SIGAA: Arquivo corrompido/)
      end
    end
  end
end