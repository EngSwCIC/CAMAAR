require 'rails_helper'

RSpec.describe "Respostas", type: :request do
  describe "GET /" do
    let(:formulario) { create(:formulario) }
    let(:questao) { create(:questao) }
    before do
      create(:resposta, texto:"Resposta A", formulario: formulario, questao: questao)
      create(:resposta, texto:"Resposta B", formulario: formulario, questao: questao)
    end

    before do
      get "/respostas"
    end

    it "returns status 200 OK" do
      expect(response).to have_http_status(200)
    end

    it "returns the respostas" do
      json_response = JSON.parse(response.body)
      expect(json_response.map { |resposta| resposta.except('created_at', 'updated_at', 'id') }).to eq([
        {"texto"=>"Resposta A", "formulario_id"=>1, "questao_id"=>1},
        {"texto"=>"Resposta B", "formulario_id"=>1, "questao_id"=>1}
      ])
    end
  end

  describe "GET /:id" do
    let(:formulario) { create(:formulario) }
    let(:questao) { create(:questao) }
    let(:resposta) { create(:resposta, texto:"Resposta A", formulario: formulario, questao: questao) }
    let(:resposta_params) do
      attributes_for(:resposta)
    end

    context "quando resposta existe" do
      before do
        get "/respostas/#{resposta.id}", params: { resposta: resposta_params }
      end

      it "returns status 200 OK" do
        expect(response).to have_http_status(200)
      end

      it "retorna a resposta" do
        json_response = JSON.parse(response.body)
        expect(json_response.except('created_at', 'updated_at', 'id')).to eq(
          {"texto"=>"Resposta A", "formulario_id"=>1, "questao_id"=>1}
        )
      end
    end

    context "quando a respota não existe" do
      it "returns status 404 Not Found" do
        get "/respostas/0", params: { resposta: resposta_params }
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "POST /" do
    let (:template) { create(:template, nome:"Template A") }
    let (:materia) { create(:materia, codigo:"TST0097", nome:"BANCOS DE TESTES") }
    let (:turma) { create(:turma, codigo:"TA", semestre:"2021.2", horario:"35T45", materia:materia)}
    let(:formulario) { create(:formulario, nome: "Avaliação A", turma:turma, template:template) }
    let(:questao) { create(:questao, texto:"Texto A", formulario:formulario, template:template) }
    let(:resposta_params) do
      attributes_for(:resposta, texto:"Resposta A", formulario_id: formulario.id, questao_id: questao.id)
    end

    context "quando os parâmetros são válidos" do
      before do
        post "/respostas", params: { resposta: resposta_params }
      end

      it "retorna status 201 Created" do
        expect(response).to have_http_status(201)
      end

      it "retorna a nova resposta" do
        json_response = JSON.parse(response.body)
        expect(json_response.except('created_at', 'updated_at', 'id')).to eq(
          {"texto"=>"Resposta A", "formulario_id"=>1, "questao_id"=>1}
        )
      end
    end

    context "quando os parâmetros são inválidos" do
      before do
        post "/respostas", params: { resposta: { texto: nil, formulario_id: nil, questao_id: nil } }
      end

      it "retorna status 400 Bad Request" do
        expect(response).to have_http_status(400)
      end
    end
  end

  describe "PATCH /:id" do
    let(:formulario) { create(:formulario) }
    let(:questao) { create(:questao) }
    let(:resposta1) { create(:resposta, texto:"Resposta 1", formulario: formulario, questao: questao) }
    let(:resposta2) { create(:resposta, texto:"Resposta 2", formulario: formulario, questao: questao) }
    let(:resposta_params) do
      attributes_for(:resposta)
    end

    context "quando os parâmetros são válidos" do
      before do
        patch "/respostas/#{resposta1.id}", params: { resposta: { texto: "Resposta 3" } }
      end

      it "retorna status 200 OK" do
        expect(response).to have_http_status(200)
      end

      it "retorna a resposta atualizada" do
        json_response = JSON.parse(response.body)
        expect(json_response.except('created_at', 'updated_at', 'id')).to eq(
          {"texto"=>"Resposta 3", "formulario_id"=>1, "questao_id"=>1}
        )
      end
    end

    context "quando os parâmetros são inválidos" do
      it "retorna status 400 Bad Request" do
        patch "/respostas/#{resposta2.id}", params: { resposta: { texto: nil, formulario_id: nil, questao_id: nil } }
        expect(response).to have_http_status(400)
      end
    end
  end

  describe "DELETE /:id" do
    let(:formulario) { create(:formulario) }
    let(:questao) { create(:questao) }
    let(:resposta) { create(:resposta, texto:"Resposta A", formulario: formulario, questao: questao) }

    context "quando a resposta existe" do
      before do
        delete "/respostas/#{resposta.id}"
      end

      it "retorna status 200 OK" do
        expect(response).to have_http_status(200)
      end

      it "retorna a mensagem 'Resposta deleted.'" do
        json_response = JSON.parse(response.body)
        expect(json_response).to eq({ "message" => "Resposta deleted." })
      end
    end

    context "quando a resposta não existe" do
      it "retorna status 404 Not Found" do
        delete "/respostas/0"
        expect(response).to have_http_status(404)
      end
    end
  end
end
