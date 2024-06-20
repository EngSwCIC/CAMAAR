require 'rails_helper'

RSpec.describe ImportUserController, type: :controller do
  describe "POST #create" do
    let(:valid_json) { File.read(Rails.root.join('spec/support/class_members.json')) }

    context "with valid JSON data" do
      it "returns a success message" do
        post :create, params: { data: valid_json }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["message"]).to eq("Data imported successfully!")
      end

      it "creates the correct records in the database" do
        expect {
          post :create, params: { data: valid_json }
        }.to change { Materia.count }.by(1)
        .and change { Turma.count }.by(1)
        .and change { User.count }.by(1)
        .and change { Matricula.count }.by(1) #ja sendo diferente de zero significa que leu e o teste daria certo
      end
    end

    context "with invalid JSON data" do
      it "returns an error message" do
        post :create, params: { data: "invalid json" }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)["message"]).to eq("Invalid JSON data format.")
      end
    end

    context "when an error occurs during import" do
      before do
        allow_any_instance_of(ImportUserController).to receive(:import_materias).and_raise(StandardError.new("Test error"))
      end

      it "returns an error message" do
        post :create, params: { data: valid_json }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)["message"]).to eq("Error importing data: Test error")
      end
    end
  end
end
