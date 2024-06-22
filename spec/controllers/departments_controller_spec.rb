require 'rails_helper'

RSpec.describe DepartamentosController, type: :controller do

  describe "GET #index" do
    it "Sucesso na requisição" do
      get :index # Requisição
      expect(response).to be_successful # Espero que a resposta seja sucess = 200
    end
  end

  describe "GET #show" do
    let(:departamento) { FactoryBot.create(:departamento) }
    it "Sucesso na requisição" do
      get :show, params: { id: departamento.id } # Requisição
      expect(response).to be_successful # Espero que a resposta seja sucess = 200
    end
  end

  describe "GET #new" do
    it "Sucesso na requisição" do
      get :new # Requisição
      expect(response).to be_successful # Espero que a resposta seja sucess = 200
    end
  end

  describe "GET #edit" do
    let(:departamento) { FactoryBot.create(:departamento) }
    it "Sucesso na requisição" do
      get :edit, params: { id: departamento.id } # Requisição
      expect(response).to be_successful # Espero que a resposta seja sucess = 200
    end
  end

  describe "POST #create" do
    it "Criando um novo departamento com sucesso" do
      expect {
        post :create, params: { departamento: attributes_for(:departamento) } # Requisição
      }.to change(Departamento, :count).by(1) # Espero que tenha aumentando o BD em 1
    end
    it "Se sucesso, redirecionar para pagina de departamento" do
      post :create, params: { departamento: attributes_for(:departamento) }  # Requisição
      expect(response).to redirect_to(departamento_url(Departamento.last)) # Espero que tenha redirecionado para pagina de departamento
    end
  end

  describe "DELETE #destroy" do
    let!(:departamento) { FactoryBot.create(:departamento) }

    it "Excluir departamento com sucesso" do
      expect {
        delete :destroy, params: { id: departamento.id } # Requisição
      }.to change(Departamento, :count).by(-1) # Espero que tenha diminuido o BD em 1
    end

    it "Se sucesso, redirecionar para pagina de departamento" do
      delete :destroy, params: { id: departamento.id } # Requisição
      expect(response).to redirect_to(departamentos_url) # Espero que tenha redirecionado para pagina de departamento
    end
  end
end