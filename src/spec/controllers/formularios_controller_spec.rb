require 'rails_helper'

RSpec.describe FormulariosController, type: :controller do
  let(:valid_attributes) {
    { id_turma: 1, id_template: 1 }
  }

  let!(:professor) { User.create!(nome: 'Professor A', email: 'professor@example.com', password: 'password123') }
  let!(:materia) { Materia.create!(nome: 'Matemática') }
  let!(:turma) { Turma.create!(classCode: 'A1', semestre: '2024-1', professor: professor, materia: materia) }
  let!(:user) { User.create!(nome: 'User A', email: 'user@example.com', password: 'password123') }
  let!(:template) { Template.create!(user: user) } # Adjust as per your Template model setup
  let!(:formulario) { Formulario.create!(valid_attributes.merge(turma: turma, template: template)) }

  describe "GET #index" do
    it "returns a success response and fetches related data with custom select" do
      get :index
      expect(response).to be_successful
      expect(assigns(:formularios)).to eq([formulario])
      expect(assigns(:formularios).first.turma_classCode).to eq('A1') # Check for turma_classCode
      expect(assigns(:formularios).first.turma_semestre).to eq('2024-1') # Check for turma_semestre
      expect(assigns(:formularios).first.professor_name).to eq('Professor A') # Check for professor_name
      expect(assigns(:formularios).first.materia_nome).to eq('Matemática') # Check for materia_nome
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: formulario.to_param }
      expect(response).to be_successful
      expect(assigns(:formulario)).to eq(formulario)
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
      expect(assigns(:formulario)).to be_a_new(Formulario)
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: { id: formulario.to_param }
      expect(response).to be_successful
      expect(assigns(:formulario)).to eq(formulario)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Formulario" do
        expect {
          post :create, params: { formulario: valid_attributes }
        }.to change(Formulario, :count).by(1)
      end

      it "redirects to the created formulario" do
        post :create, params: { formulario: valid_attributes }
        expect(response).to redirect_to(Formulario.last)
        expect(flash[:notice]).to eq('Formulario was successfully created.')
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e., to display the 'new' template)" do
        post :create, params: { formulario: invalid_attributes }
        expect(response).to be_unprocessable
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { id_turma: 2 }
      }

      it "updates the requested formulario" do
        put :update, params: { id: formulario.to_param, formulario: new_attributes }
        formulario.reload
        expect(formulario.id_turma).to eq(2)
      end

      it "redirects to the formulario" do
        put :update, params: { id: formulario.to_param, formulario: new_attributes }
        expect(response).to redirect_to(formulario)
        expect(flash[:notice]).to eq('Formulario was successfully updated.')
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e., to display the 'edit' template)" do
        put :update, params: { id: formulario.to_param, formulario: invalid_attributes }
        expect(response).to be_unprocessable
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested formulario" do
      expect {
        delete :destroy, params: { id: formulario.to_param }
      }.to change(Formulario, :count).by(-1)
    end

    it "redirects to the formularios list" do
      delete :destroy, params: { id: formulario.to_param }
      expect(response).to redirect_to(formularios_url)
      expect(flash[:notice]).to eq('Formulario was successfully destroyed.')
    end
  end
end
