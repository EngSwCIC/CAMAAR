require 'rails_helper'

RSpec.describe "Questoes", type: :request do
  describe "GET /" do
    # texto, formulario, template
    let (:formulario) { create(:formulario) }
    let (:template) { create(:template) } # -> template_id = 2, talvez porque formulário já instancia um template_id = 1
    before do
      create(:questao, texto:"Texto da questão.", formulario:formulario, template:template)
      create(:questao, texto:"Texto da questão.", formulario:formulario, template:template)
    end

    context "quando existem questões" do
      before do
        get "/questoes"
      end

      it "retorna status 200 OK" do
        expect(response).to have_http_status(200)
      end

      it "retorna as questões" do
        json_response = JSON.parse(response.body)
        expect(json_response.map { |questao| questao.except('created_at', 'updated_at', 'id') }).to eq([
          {"texto"=>"Texto da questão.", "formulario_id"=>1, "template_id"=>2},
          {"texto"=>"Texto da questão.", "formulario_id"=>1, "template_id"=>2}
        ])
      end
    end
  end

  describe "GET /:id" do
    let (:formulario) { create(:formulario) }
    let (:template) { create(:template) }
    let (:questao) { create(:questao, texto:"Texto da questão.", formulario:formulario, template:template) }
    let(:questao_params) do
      attributes_for(:questao)
    end

    context "quando a questão existe" do
      before do
        get "/questoes/#{questao.id}", params: { questao: questao_params }
      end

      it "retorna status 200 OK" do
        expect(response).to have_http_status(200)
      end

      it "retorna a questão" do
        json_response = JSON.parse(response.body)
        expect(json_response.except('created_at', 'updated_at', 'id')).to eq(
          {"texto"=>"Texto da questão.", "formulario_id"=>1, "template_id"=>2}
        )
      end
    end

    context "quando a questão não existe" do
      it "retorna status 404 Not Found" do
        get "/questoes/0", params: { questao: questao_params }
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "POST /" do
    let (:template) { create(:template, nome:"Template A") }
    let (:materia) { create(:materia, codigo:"TST0097", nome:"BANCOS DE TESTES") }
    let (:turma) { create(:turma, codigo:"TA", semestre:"2021.2", horario:"35T45", materia:materia) }
    let (:formulario) { create(:formulario, nome: "Avaliação A", turma:turma, template:template) }
    let(:questao_params) do
      { texto: "Texto da questão.", formulario_id: formulario.id, template_id: template.id}
    end

    context "quando os parâmetros são válidos" do
      before do
        post "/questoes", params: { questao: questao_params }
      end

      it "retorna status 201 Created" do
        expect(response).to have_http_status(201)
      end

      it "cria a questão" do
        json_response = JSON.parse(response.body)
        expect(json_response.except('created_at', 'updated_at', 'id')).to eq(
          { "texto"=>"Texto da questão.", "formulario_id"=>1, "template_id"=>1 }
        )
      end
    end

    context "quando os parâmetros não são válidos" do
      it "retorna status 400 Bad Request" do
        post "/questoes", params: { questao: { texto: nil, formulario_id: nil, template_id: nil } }
        expect(response).to have_http_status(400)
      end
    end
  end

  describe "PATCH /:id" do
    let (:template) { create(:template) }
    let (:formulario) { create(:formulario) }
    let (:questao1) { create(:questao, texto:"Questão 1.", formulario:formulario, template:template) }
    let (:questao2) { create(:questao, texto:"Questão 2.", formulario:formulario, template:template) }
    let(:questao_params) do
      attributes_for(:questao)
    end

    context "quando os parâmetros são válidos" do
      before do
        patch "/questoes/#{questao1.id}", params: { questao: { texto: "Questão 3." } }
      end

      it "retorna status 200 OK" do
        expect(response).to have_http_status(200)
      end

      it "retorna a questão atualizada" do
        json_response = JSON.parse(response.body)
        expect(json_response.except('created_at', 'updated_at', 'id')).to eq(
          {"texto"=>"Questão 3.", "formulario_id"=>1, "template_id"=>2}
        )
      end
    end

    context "quando os parâmetros não são válidos" do
      it "retorna HTTP status 400 Bad Request" do
        patch "/questoes/#{questao2.id}", params: { questao: { texto: nil, formulario_id: nil, template_id: nil } }
        expect(response).to have_http_status(400)
      end
    end
  end

  describe "DELETE /:id" do
    let (:template) { create(:template) }
    let (:formulario) { create(:formulario) }
    let (:questao) { create(:questao, texto:"Questão 1.", formulario:formulario, template:template) }

    context "quando a questão existe" do
      it "retorna status 200 OK" do
        delete "/questoes/#{questao.id}"
        expect(response).to have_http_status(200)
      end
    end

    context "quando a questão não existe" do
      it "retorna HTTP status 404 Not Found" do
        delete "/questoes/0"
        expect(response).to have_http_status(404)
      end
    end
  end

end
