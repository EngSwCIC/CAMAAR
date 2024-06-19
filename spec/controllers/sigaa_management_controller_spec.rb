require 'rails_helper'

RSpec.describe SigaaManagementController, type: :controller do
  describe "POST #import_sigaa_data" do
    it "imports data successfully and redirects to manager_path" do
      post :import_sigaa_data
      expect(response).to redirect_to(manager_path)
      expect(flash[:success]).to eq("Dados importados com sucesso!")
    end
  end

  describe "POST #update_sigaa_data" do
    context "when semester is present" do
      before do
        allow(Semester).to receive(:current_semester_id).and_return(1)
      end

      it "updates data successfully and redirects to manager_path" do
        post :update_sigaa_data
        expect(response).to redirect_to(manager_path)
        expect(flash[:success]).to eq("Dados atualizados com sucesso!")
      end
    end

    context "when semester is not present" do
      before do
        allow(Semester).to receive(:current_semester_id).and_return(nil)
      end

      it "sets flash error and redirects to manager_path" do
        post :update_sigaa_data
        expect(response).to redirect_to(manager_path)
        expect(flash[:error]).to eq("Não é possível atualizar os dados sem um semestre cadastrado, importe os dados do sistema.")
      end
    end
  end

  describe "POST #send_email_availables_sign_up" do
    it "sends email and sets flash success" do
      expect(SignUpAvailable).to receive(:send_keys_availables_sign_up)
      post :send_email_availables_sign_up
      expect(response).to redirect_to(manager_path)
      expect(flash[:success]).to eq("Chave de acesso enviada para todos os Alunos Importados do SIGAA.")
    end
  end
end
