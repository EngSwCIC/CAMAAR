require 'rails_helper'

RSpec.describe "Turmas", type: :request do
  # Precisa de um create pra turma? Elas são imprtadas do SIGAA, não criadas aqui.
  # describe "POST /create" do
  #   it "cria uma nova turma" do
  #     let (:turma_params) do
  #       attributes_for(:turma)
  #     end

  #     context "quando os parâmetros são válidos" do
  #       it "retorna status 201 Created" do
  #         post "/turmas/create", params: { turma: turma_params }
  #         expect(response).to have_http_status(201)
  #       end
  #     end
  #   end
  # end


  describe "GET /" do # index
    let (:materia) { create(:materia, codigo:"TST0097", nome:"BANCOS DE TESTES") }
    before do
      create(:turma, materia: materia, codigo:"TA", semestre:"2020.1", horario:"24M12")
      create(:turma, materia: materia, codigo:"TB", semestre:"2020.1", horario:"35T34")
    end

    context "quando existem turmas" do
      before do
        get "/turmas"
      end

      it "retorna todas as turmas com HTTP Status ok" do
        expect(response).to have_http_status(200)
      end

      it "retorna um JSON com as turmas" do
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "retorna as turmas corretas" do
        json_response = JSON.parse(response.body)
        expect(json_response.map { |turma| turma.except('created_at', 'updated_at', 'id') }).to eq([
        {
          "codigo" => "TA",
          "semestre" => "2020.1",
          "horario" => "24M12",
          "materia_id"=>1,
        },
        {
          "codigo" => "TB",
          "semestre" => "2020.1",
          "horario" => "35T34",
          "materia_id"=>1,
        }
      ])
      end
    end
  end

  describe "GET /:id" do
    let (:materia) { create(:materia, codigo:"TST0097", nome:"BANCOS DE TESTES") }
    let (:turma) { create(:turma, materia:materia) } # { create(:turma, materia: materia, codigo:"TA", semestre:"2020.1", horario:"24M12") }
    let (:turma_params) do
      attributes_for(:turma)
    end

    context "quando a turma existe" do
      it "retorna uma turma com HTTP status ok" do
        get "/turmas/#{turma.id}", params: { turma: turma_params }
        expect(response).to have_http_status(200)
      end
    end

    context "quando a turma não existe" do
      it "retorna HTTP status 404 Not Found" do
        get "/turmas/0", params: { turma: turma_params }
        expect(response).to have_http_status(404)
      end
    end
  end

end
