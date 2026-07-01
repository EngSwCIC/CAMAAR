require 'rails_helper'

RSpec.describe "Respostas", type: :request do
  describe "POST /resposta" do
    it "cria uma submissão com uma resposta por questão do formulário" do
      user = create(:user)
      formulario = create(:formulario)
      questao_rating = create(:questao, :de_formulario, formulario: formulario, tipo: "rating")
      questao_texto = create(:questao, :de_formulario, formulario: formulario, tipo: "text")

      login_as(user)

      parametros = {
        respostum: {
          formulario_id: formulario.id,
          respostas: {
            questao_rating.id.to_s => { valor: "5" },
            questao_texto.id.to_s => { valor: "Ótima aula" }
          }
        }
      }

      expect {
        post "/resposta", params: parametros
      }.to change(Respostum, :count).by(2).and change(Submissao, :count).by(1)

      expect(response).to redirect_to(formularios_path)

      submissao = Submissao.find_by(user: user, formulario: formulario)
      expect(submissao.respostas.find_by(questao: questao_rating).valor_numerico).to eq(5)
      expect(submissao.respostas.find_by(questao: questao_texto).valor_texto).to eq("Ótima aula")
    end

    it "mapeia resposta booleana para o valor numérico enviado" do
      user = create(:user)
      formulario = create(:formulario)
      questao = create(:questao, :de_formulario, formulario: formulario, tipo: "boolean")

      login_as(user)

      post "/resposta", params: {
        respostum: { formulario_id: formulario.id, respostas: { questao.id.to_s => { valor: "1" } } }
      }

      submissao = Submissao.find_by(user: user, formulario: formulario)
      expect(submissao.respostas.find_by(questao: questao).valor_numerico).to eq(1)
    end

    it "não cria nenhuma resposta quando uma questão é deixada em branco" do
      user = create(:user)
      formulario = create(:formulario)
      questao_um = create(:questao, :de_formulario, formulario: formulario, tipo: "rating")
      questao_dois = create(:questao, :de_formulario, formulario: formulario, tipo: "text")

      login_as(user)

      parametros = {
        respostum: {
          formulario_id: formulario.id,
          respostas: {
            questao_um.id.to_s => { valor: "5" },
            questao_dois.id.to_s => { valor: "" }
          }
        }
      }

      expect {
        post "/resposta", params: parametros
      }.not_to change(Respostum, :count)

      expect(response).to redirect_to(formulario_path(formulario))
      follow_redirect!
      expect(response.body).to include("Por favor, preencha todas as questões obrigatórias")
    end
  end
end
