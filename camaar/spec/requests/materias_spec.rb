require 'rails_helper'

RSpec.describe "Materias", type: :request do
  let!(:materia) { create(:materia) }
  let(:materia_params) { { nome: "Materia de Teste", codigo: "TES0000" } }

  describe "obter Materias - GET #index" do
    it "foi bem sucedida" do
      get materias_path, headers: {'Accept' => 'application/json'}
      expect(response).to be_successful
    end
    it "obteve o objeto de teste" do
      get materias_path, headers: {'Accept' => 'application/json'}
      materias = JSON.parse(response.body)
      teste = false
      for materia_ in materias do
        if materia_["id"] == materia.id
          teste = true
        end
      end
      expect(teste).to eq(true)
    end
  end
  describe "obter Materia - GET #show" do
    it "foi bem sucedida" do
      get materia_path(materia), headers: {'Accept' => 'application/json'}
      expect(response).to be_successful
    end
    it "obteve o objeto certo" do
      get materia_path(materia), headers: {'Accept' => 'application/json'}
      
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(materia.id)
      expect(json["nome"]).to eq(materia.nome)
      expect(json["codigo"]).to eq(materia.codigo)
    end
  end
  describe "GET #new" do
    it "foi bem sucedida" do
      get new_materia_path
      expect(response).to be_successful
    end
  end
  describe "POST #create" do
    context "Parametros válidos" do
      it "foi bem sucedida" do
        post materias_path, params: { materia: materia_params }
        expect(response).to redirect_to(materias_path)
      end
    end
    context "Parametros inválidos" do
      it "foi mal sucedida" do
        post materias_path, params: {"oi": "tudo bom?"}
        expect(response).to have_http_status(400)
      end
    end
  end
end
