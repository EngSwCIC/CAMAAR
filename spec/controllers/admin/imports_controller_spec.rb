require 'rails_helper'

RSpec.describe Admin::ImportsController, type: :controller do
  let(:admin_user) { User.create!(email: 'admin@test.com', matricula: '123', password: 'password', password_confirmation: 'password', role: 'admin') }

  before do
    session[:user_id] = admin_user.id
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "when file is missing" do
      it "redirects with an alert" do
        post :create
        expect(response).to redirect_to(admin_imports_path)
        expect(flash[:alert]).to eq("Por favor, selecione um arquivo para importar")
      end
    end

    context "when file has invalid format" do
      it "redirects with an alert" do
        file = fixture_file_upload(Tempfile.new(['test', '.txt']).path, 'text/plain')
        post :create, params: { file: file, import_type: 'classes' }
        expect(response).to redirect_to(admin_imports_path)
        expect(flash[:alert]).to eq("Formato de arquivo inválido. Por favor, envie um arquivo .json")
      end
    end

    context "when file is valid JSON" do
      let(:json_content) { '[{"id": 1}]' }
      let(:file) do
        temp = Tempfile.new(['test', '.json'])
        temp.write(json_content)
        temp.rewind
        fixture_file_upload(temp.path, 'application/json')
      end

      it "imports classes successfully" do
        expect(SigaaImporter).to receive(:import_classes).with(json_content).and_return({ success: true, message: "Importado com sucesso" })
        post :create, params: { file: file, import_type: 'classes' }
        expect(response).to redirect_to(admin_imports_path)
        expect(flash[:notice]).to eq("Importado com sucesso")
      end

      it "handles import classes failure" do
        expect(SigaaImporter).to receive(:import_classes).with(json_content).and_return({ success: false, message: "Erro na importação" })
        post :create, params: { file: file, import_type: 'classes' }
        expect(response).to redirect_to(admin_imports_path)
        expect(flash[:alert]).to eq("Erro na importação")
      end

      it "imports members successfully" do
        expect(SigaaImporter).to receive(:import_members).with(json_content).and_return({ success: true, message: "Importado com sucesso" })
        post :create, params: { file: file, import_type: 'members' }
        expect(response).to redirect_to(admin_imports_path)
        expect(flash[:notice]).to eq("Importado com sucesso")
      end
    end
  end
end
