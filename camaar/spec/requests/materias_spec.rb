require 'rails_helper'

RSpec.describe "Materias", type: :request do
  let!(:materia) { create(:materia) }

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
end
