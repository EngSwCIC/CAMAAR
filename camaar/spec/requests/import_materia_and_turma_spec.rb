require 'hashie'
RSpec.describe "ImportMateriaAndTurmaController", type: :controller do
  #let(:valid_json) do
  #  { data: [
  #    { code: "MAT101", name: "Mathematics 1", class: { classCode: "TURMA_A", semester: "2021.2", time: "10:00-11:00" } },
  #    { code: "PHY101", name: "Physics 1", class: { classCode: "TURMA_B", semester: "2021.2", time: "14:00-15:00" } }
  #  ] }
  #
  let(:data) { File.read(Rails.root.join('spec/support/classes.json')) }

  describe "POST #create" do
    context "with valid JSON data" do
      it "imports data successfully" do

        post :create, params: { data: data }, as: :json

        expect(response).to have_http_status(:created)
        expect(response.parsed_body).to eq({ "message" => "Data imported successfully!" })

        # Additional assertions for data creation
        expect(Materia.count).to eq(3)
        expect(Materia.first.codigo).to eq("CIC0097")
        expect(Materia.first.turmas.first.codigo).to eq("TA")
      end
    end

    context "with invalid JSON data" do
      let(:invalid_json) do
        { data: { code: "MAT101", name: "Mathematics 1" } } # Missing class data
      end

      it "returns bad request for invalid format" do
        post :create, params: invalid_json

        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body).to eq({ "message" => "Invalid JSON data format." })
      end
    end

    #context "with data import error" do
    #  it "handles errors and returns bad request" do
        # Mock Materia.create! to raise an error
    #    allow(Materia).to receive(:create!).and_raise(StandardError, "Data saving failed!")

    #    post :create, params: { data: data }, as: :json

    #    expect(response).to have_http_status(:bad_request)
    #    expect(response.parsed_body).to eq({ "message" => "Error importing data: Data saving failed!" })
    #  end
    #end
  end
end
