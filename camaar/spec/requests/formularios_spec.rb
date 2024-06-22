require 'rails_helper'

RSpec.describe "Formularios", type: :request do
  describe "GET /" do
    # Nome, Turma, Template
    let (:template) { create(:template) }
    let (:turma) { create(:turma) }
    before do
      create(:formulario, nome:"Avaliação A", turma:turma, template:template)
      create(:formulario, nome:"Avaliação B", turma:turma, template:template)
    end

    context "quando existem formulários" do
      before do
        get "/formularios", as: :json
      end

      it "retorna status 200 OK" do
        expect(response).to have_http_status(200)
      end

      it "retorna os formulários" do
        json_response = JSON.parse(response.body)
        expect(json_response.map { |formulario| formulario.except('created_at', 'updated_at', 'id') }).to eq([
          {"nome"=>"Avaliação A", "turma_id"=>1, "template_id"=>1},
          {"nome"=>"Avaliação B", "turma_id"=>1, "template_id"=>1}
        ])
      end
    end
  end

  describe "GET /:id" do
    let (:template) { create(:template) }
    let (:turma) { create(:turma) }
    let (:formulario) { create(:formulario, nome:"Avaliação A", turma:turma, template:template) }
    let(:formulario_params) do
      attributes_for(:formulario)
    end

    context "quando o formulário existe" do
      before do
        get "/formularios/#{formulario.id}", params: { formulario: formulario_params }, as: :json
      end

      it "retorna status 200 OK" do
        expect(response).to have_http_status(200)
      end

      it "retorna o formulário" do
        json_response = JSON.parse(response.body)
        expect(json_response.except('created_at', 'updated_at', 'id')).to eq(
          {"nome"=>"Avaliação A", "turma_id"=>1, "template_id"=>1}
        )
      end
    end

    context "quando o formulário não existe" do
      it "retorna status 404 Not Found" do
        get "/formularios/0", params: { formulario: formulario_params }
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "POST /" do
    let (:template) { create(:template, nome:"Template A") }
    let (:materia) { create(:materia, codigo:"TST0097", nome:"BANCOS DE TESTES") }
    let (:turma) { create(:turma, codigo:"TA", semestre:"2021.2", horario:"35T45", materia:materia)}
    let (:formulario_params) do
      { nome: "Avaliação A", turma_id: turma.id, template_id: template.id }
    end
    before do
      post "/formularios", params: { formulario: formulario_params }
    end

    context "quando os parâmetros são válidos" do
      it "retorna status 201 Created" do
        expect(response).to have_http_status(201)
      end

      it "retorna o formulário criado" do
        json_response = JSON.parse(response.body)
        expect(json_response.except('created_at', 'updated_at', 'id')).to eq(
          {"nome"=>"Avaliação A", "turma_id"=>1, "template_id"=>1}
        )
      end
    end
  end

  describe "PATCH /:id" do
    let (:template) { create(:template) }
    let (:turma) { create(:turma) }
    let (:formularioA) { create(:formulario, nome:"Avaliação A", turma:turma, template:template) }
    let (:formularioB) { create(:formulario, nome:"Avaliação B", turma:turma, template:template) }
    let(:formulario_params) do
      attributes_for(:formulario)
    end

    context "quando os parâmetros estão ok" do
      before do
        patch "/formularios/#{formularioA.id}", params: { formulario: { nome: "Avaliação C" } }
      end

      it "retorna status 200 OK" do
        expect(response).to have_http_status(200)
      end

      it "retorna o formulário atualizado" do
        json_response = JSON.parse(response.body)
        expect(json_response.except('created_at', 'updated_at', 'id')).to eq(
          {"nome"=>"Avaliação C", "turma_id"=>1, "template_id"=>1}
        )
      end
    end

    context "quando os parâmetros são inválidos" do
      it "retorna HTTP status bad request" do
        patch "/formularios/#{formularioB.id}", params: { formulario: { nome:nil } }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe "DELETE /:id" do
    let (:template) { create(:template) }
    let (:turma) { create(:turma) }
    let (:formulario) { create(:formulario, nome:"Avaliação A", turma:turma, template:template) }

    context "quando o formulário existe" do
      it "retorna HTTP status ok" do
        delete "/formularios/#{formulario.id}"
        expect(response).to have_http_status(200)
      end
    end

    context "quando o formulário não existe" do
      it "retorna HTTP status not_found" do
        delete "/formularios/0"
        expect(response).to have_http_status(404)
      end
    end
  end

end
