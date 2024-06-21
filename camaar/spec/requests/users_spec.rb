require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /" do
    before do
      create(:user, nome:"João", email:"jao@exemplo.com", curso:"CIÊNCIA DA COMPUTAÇÃO/CIC", matricula:"190084001", formacao:"graduando", ocupacao:"dicente", role: :user)
      create(:user, nome:"Maria", email:"maria@exemplo.com", curso:"CIÊNCIA DA COMPUTAÇÃO/CIC", matricula:"190084002", formacao:"graduando", ocupacao:"dicente", role: :user)
    end

    context "quando existem usuários" do
      before do
        get "/users"
      end

      it "retorna status 200 OK" do
        expect(response).to have_http_status(200)
      end

      it "retorna os usuários" do
        json_response = JSON.parse(response.body)
        expect(json_response.map { |user| user.except('id') }).to eq([
          {"nome"=>"João", "email"=>"jao@exemplo.com", "curso"=>"CIÊNCIA DA COMPUTAÇÃO/CIC", "matricula"=>"190084001", "formacao"=>"graduando", "ocupacao"=>"dicente", "role"=>"user"},
          {"nome"=>"Maria", "email"=>"maria@exemplo.com", "curso"=>"CIÊNCIA DA COMPUTAÇÃO/CIC", "matricula"=>"190084002", "formacao"=>"graduando", "ocupacao"=>"dicente", "role"=>"user"}
        ])
      end
    end
  end

  describe "GET /:id" do
    let(:user) { create(:user, nome:"João", email:"jao@exemplo.com", curso:"CIÊNCIA DA COMPUTAÇÃO/CIC", matricula:"190084001", formacao:"graduando", ocupacao:"dicente", role:"user") }
    let(:user_params) do
      attributes_for(:user)
    end

    context "quando o usuário existe" do
      before do
        get "/users/#{user.id}", params: { user: user_params }
      end

      it "retorna status 200 OK" do
        expect(response).to have_http_status(200)
      end

      it "retorna o usuário" do
        json_response = JSON.parse(response.body)
        expect(json_response.except('id')).to eq(
          {"nome"=>"João", "email"=>"jao@exemplo.com", "curso"=>"CIÊNCIA DA COMPUTAÇÃO/CIC", "matricula"=>"190084001", "formacao"=>"graduando", "ocupacao"=>"dicente", "role"=>"user"}
        )
      end
    end

    context "quando o usuário não existe" do
      it "retorna status 404 Not Found" do
        get "/users/0", params: { user: user_params }
        expect(response).to have_http_status(404)
      end
    end
  end

  # describe "POST /" do
  #   let(:user_params) do
  #     {
  #       nome:"João", email:"jao@exemplo.com", password:"123456", curso:"CIÊNCIA DA COMPUTAÇÃO/CIC", matricula:"190084001", formacao:"graduando", ocupacao:"dicente",
  #     }
  #   end

  #   before do
  #     post "/users", params: { user: user_params }
  #   end

  #   context "quando os parâmetros são válidos" do
  #     it "retorna status 201 Created" do
  #       expect(response).to have_http_status(201)
  #     end

  #     it "retorna o novo usuário" do
  #       json_response = JSON.parse(response.body)
  #       expect(json_response.except('id')).to eq(
  #         {"nome"=>"João", "email"=>"jao@exemplo.com", "curso"=>"CIÊNCIA DA COMPUTAÇÃO/CIC", "matricula"=>"190084001", "formacao"=>"graduando", "ocupacao"=>"dicente", "role"=>"user"}
  #       )
  #     end
  #   end
  # end

  # describe "PATCH /:id" do
  #   let(:userA) { create(:user, nome:"JoãoA", email:"jao@exemplo.com", password:"123456", curso:"CIÊNCIA DA COMPUTAÇÃO/CIC", matricula:"190084001", formacao:"graduando", ocupacao:"dicente", role:"user") }
  #   let(:userB) { create(:user, nome:"Maria", email:"maria@exemplo.com", password:"456789", curso:"CIÊNCIA DA COMPUTAÇÃO/CIC", matricula:"190084002", formacao:"graduando", ocupacao:"dicente", role:"user") }
  #   let(:user_params) do
  #     attributes_for(:user)
  #   end

  #   context "quando os parâmetros são válidos" do
  #     before do
  #       patch "/users/#{userA.id}", params: { user: { nome: "João" } }
  #     end

  #     it "retorna status 200 OK" do
  #       expect(response).to have_http_status(200)
  #     end

  #     it "retorna o usuário atualizado" do
  #       json_response = JSON.parse(response.body)
  #       expect(json_response.except('id')).to eq(
  #         {"nome"=>"João", "email"=>"jao@exemplo.com", "curso"=>"CIÊNCIA DA COMPUTAÇÃO/CIC", "matricula"=>"190084001", "formacao"=>"graduando", "ocupacao"=>"dicente", "role"=>"user"}
  #       )
  #     end
  #   end

  #   context "quando os parâmetros são inválidos" do
  #     it "retorna status bad request" do
  #       patch "/users/#{userB.id}", params: { user: { email: "jao" } }
  #       expect(response).to have_http_status(:bad_request)
  #     end
  #   end
  # end

  context "DELETE /:id" do
    let(:user) { create(:user, nome:"João", email:"jao@exemplo.com", curso:"CIÊNCIA DA COMPUTAÇÃO/CIC", matricula:"190084001", formacao:"graduando", ocupacao:"dicente", role:"user") }

    context "quando o usuário existe" do
      it "retorna status 200 OK" do
        delete "/users/#{user.id}"
        expect(response).to have_http_status(200)
      end
    end

    context "quando o usuário não existe" do
      it "retorna status 404 Not Found" do
        delete "/users/0"
        expect(response).to have_http_status(404)
      end
    end
  end
end

RSpec.describe UsersController, type: :controller do
  let(:data) { File.read(Rails.root.join('spec/support/class_members.json')) }
  let(:materia) { Materia.create!(codigo: "CIC0097", name: "BANCO DE DADOS") }
  let(:turma) { Turma.create!(codigo: "TA", semester: "2021.2", horario: "35T45", materia: materia) }
  describe "POST #create" do
    context "with valid JSON data" do
      it "returns a success message" do
        post :create, params: { data: data }, as: :json
        expect(response.parsed_body).to eq({ "message" => "Data imported successfully!" })
        expect(response).to have_http_status(:created)
      end

      it "creates the correct records in the database" do
        expect {
          post :create, params: { data: data }, as: :json
        }.to change { Materia.count }.by(1)
        .and change { Turma.count }.by(1)
        .and change { User.count }.by(44)
        .and change { Matricula.count }.by(44)
      end
    end

    context "with invalid JSON data" do
      let(:invalid_json) do
        { data: { code: "MAT101", name: "Mathematics 1" } } # Missing class data
      end
      it "returns an error message" do
        post :create, params: invalid_json
        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body).to eq({ "message" => "Invalid JSON data format." })
      end
    end
  end
end
