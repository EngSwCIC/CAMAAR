require 'rails_helper'

RSpec.describe "Matriculas", type: :request do
  # TODO -> Estou com problemas pra fazer isso e talvez não seja necessário
  describe "POST /create" do
    # let (:user) { create(:user, nome:"Ana Clara Jordao Perna", email:"acjpjvjp@gmail.com", password:"123456", curso:"CIÊNCIA DA COMPUTAÇÃO/CIC", matricula:"190084006", formacao:"graduando", ocupacao:"dicente", admin:false) }
    # let (:materia) { create(:materia, codigo:"TST0097", nome:"BANCOS DE TESTES") }
    # let (:turma) { create(:turma, codigo:"TA", semestre:"2021.1", horario:"35T45", materia:materia) }
    let (:user) { create(:user) }
    # let (:materia) { create(:materia) }
    let (:turma) { create(:turma) }
    let (:matricula_params) do
      { user_id: user.id, turma_id: turma.id }
    end

    before do
      post "/matriculas", params: { matricula: matricula_params }
    end

    context "quando os parâmetros são válidos" do
      it "retorna status 201 Created" do
        expect(response).to have_http_status(201)
      end

      it "retorna a matricula criada" do
        json_response = JSON.parse(response.body)
        expect(json_response.except('created_at', 'updated_at', 'id')).to eq(
          {"turma_id"=>1, "user_id"=>1}
        )
      end
    end
  end

  # delete "/:id", to: "matriculas#delete"
  describe "DELETE /:id" do
    let (:user) { create(:user) }
    let (:materia) { create(:materia) }
    let (:turma) { create(:turma) }
    let (:matricula) { create(:matricula, turma:turma, user:user) }

    context "quando a matricula existe" do
      it "retorna HTTP status ok" do
        # matricula = Matricula.create(matricula_params)
        delete "/matriculas/#{matricula.id}"
        expect(response).to have_http_status(200)
      end
    end

    context "quando a matricula não existe" do
      it "retorna HTTP status not_found" do
        delete "/matriculas/0"
        expect(response).to have_http_status(404)
      end
    end
  end

  # get "/", to: "matriculas#index"
  describe "GET /" do
    let (:user1) { create(:user, nome:"Ana Clara Jordao Perna", email:"acjpjvjp@gmail.com", password:"123456", curso:"CIÊNCIA DA COMPUTAÇÃO/CIC", matricula:"190084006", formacao:"graduando", ocupacao:"dicente", admin:false) }
    let (:user2) { create(:user, nome:"Joao Oajo Aooj", email:"jooj@gmail.com", password:"789012", curso:"CIÊNCIA DA COMPUTAÇÃO/CIC", matricula:"190085007", formacao:"graduando", ocupacao:"dicente", admin:false) }
    let (:materia) { create(:materia, codigo:"TST0097", nome:"BANCOS DE TESTES") }
    let (:turma) { create(:turma, codigo:"TA", semestre:"2021.1", horario:"35T45", materia:materia) }
    before do
      create(:matricula, user: user1, turma: turma)
      create(:matricula, user: user2, turma: turma)
    end

    context "quando existem matriculas" do
      before do
        get "/matriculas"
      end

      it "retorna HTTP status ok" do
        expect(response).to have_http_status(200)
      end

      it "retorna um json com as matriculas" do
        json_response = JSON.parse(response.body)
        expect(json_response.map { |matricula| matricula.except('created_at', 'updated_at', 'id') }).to eq([
          {"turma_id"=>1, "user_id"=>1},
          {"turma_id"=>1, "user_id"=>2}
        ])
      end
    end
  end
end
