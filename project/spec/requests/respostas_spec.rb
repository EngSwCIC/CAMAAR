require 'rails_helper'

RSpec.describe "Respostas", type: :request do
  describe "POST /resposta" do
    it "cria uma nova resposta mapeando a nota corretamente para o atributo do banco" do
      submissao = create(:submissao)
      questao = create(:questao, :de_formulario, formulario: submissao.formulario)

      # Parâmetros usando o nome exato do Schema para sincronização perfeita
      parametros = {
        respostum: {
          valor_numerico: 10,
          valor_texto: "Ótima aula",
          submissao_id: submissao.id,
          questao_id: questao.id
        }
      }

      # Valida se o registro foi criado no banco
      expect {
        post "/resposta", params: parametros
      }.to change(Respostum, :count).by(1)

      expect(response).to be_redirect
      
      # Garante a sincronização
      nova_resposta = Respostum.last
      expect(nova_resposta.valor_numerico).to eq(10)
    end
  end
end