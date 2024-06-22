require 'rails_helper'

RSpec.describe MateriaController, type: :controller do
  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      materia = FactoryBot.create(:materia)
      get :show, params: { id: materia.to_param }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      materia = FactoryBot.create(:materia)
      get :edit, params: { id: materia.to_param }
      expect(response).to be_successful
    end
  end
end
