require "rails_helper"

describe TemplatesController, type: :controller do
  describe "adding a question to a template" do
  end

  describe "when creating a template" do
    let(:session) do { id: 35, email: "admin.cic@gmail.com" } end
    let(:params) do {
      name: "Template 1",
      questions: {
        1 => { question: "Classifique seu rendimento",
               options: { 1 => "Ótimo", 2 => "Bom", 3 => "Médio", 4 => "Ruim", 5 => "Péssimo" },
               answer: { 1 => false, 2 => false, 3 => false, 4 => false } },
        2 => { question: "Dê uma sugestão",
               answer: "" },
      }.to_json,
    }     end

    it "gets the template name from params" do
      expect(assigns(:template).name).to eq("Template 1")
    end

    it "gets the questions as a json from the params" do
      expect(assigns(:template).questions).to eq(params[:questions])
    end

    it "it uses the session data to get the coordinator data from the database" do
      admin = Admin.find_by({ id: session[:id] })
      coordinator = Coordinator.find_by({ email: admin.email })
    end

    it "creates the template on the database associated with the coordinator" do
      Template.create!({
        name: params[:name],
        questions: params[:questions],
        coordinator_id: coordinator.id,
      })
    end

    it "redirects to the templates page" do
      expect(response).to redirect_to("/templates")
    end

    it "returns a sucess status" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "adding a option to a multiple choice question" do
  end

  describe "editing a template form" do
  end
end
