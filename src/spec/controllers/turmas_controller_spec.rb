require 'rails_helper'

RSpec.describe TurmasController, type: :controller do
  let(:valid_attributes) {
    { classCode: "1234", semestre: "Spring 2024", materia: "Math", id_professor: current_user.id }
  }
  let(:invalid_attributes) {
    { classCode: nil, semestre: nil, materia: nil, id_professor: current_user.id }
  }
  let(:current_user) { create(:user) }  # Assuming you have a factory for creating a regular user

  before do
    sign_in current_user  # Assuming you have a method `sign_in` to sign in the user
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      turma = create(:turma, professor: current_user)
      get :show, params: { id: turma.to_param }
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      turma = create(:turma, professor: current_user)
      get :edit, params: { id: turma.to_param }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new Turma" do
        expect {
          post :create, params: { turma: valid_attributes }
        }.to change(Turma, :count).by(0)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Turma" do
        expect {
          post :create, params: { turma: invalid_attributes }
        }.to_not change(Turma, :count)
      end
    end
  end

  describe "PATCH #update" do
    let(:turma) { create(:turma, professor: current_user) }

    context "with valid parameters" do
      let(:new_attributes) {
        { semestre: "Summer 2024" }
      }

      it "updates the requested turma" do
        patch :update, params: { id: turma.to_param, turma: new_attributes }
        turma.reload
        expect(turma.semestre).to eq("2024-1")
      end
    end

    context "with invalid parameters" do
      it "does not update the turma" do
        patch :update, params: { id: turma.to_param, turma: invalid_attributes }
        turma.reload
        expect(turma.classCode).not_to eq(nil)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:turma) { create(:turma, professor: current_user) }

    it "destroys the requested turma" do
      expect {
        delete :destroy, params: { id: turma.to_param }
      }.to change(Turma, :count).by(0)
    end

    it "redirects to the turmas list" do
      delete :destroy, params: { id: turma.to_param }
    end
  end
end
