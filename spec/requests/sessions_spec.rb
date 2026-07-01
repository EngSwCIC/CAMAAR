require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  before(:each) do
    @pessoa = Pessoa.create!(
      usuario: '190000000', 
      email: 'arrascaeta@unb.br', 
      nome: 'Giorgian de Arrascacheira', 
      password: 'senha_segura', 
      password_confirmation: 'senha_segura'
    )
  end

  describe "POST /login" do
    context "Happy Path" do
      it "faz login com credenciais válidas e redireciona para a home" do
        post '/login', params: { login: 'arrascaeta@unb.br', password: 'senha_segura' }
        expect(response).to have_http_status(:redirect).or(have_http_status(:success))
      end
    end

    context "Sad Path" do
      it "rejeita o login com senha incorreta e renderiza a tela novamente" do
        post '/login', params: { login: 'arrascaeta@unb.br', password: 'senha_errada' }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /logout" do
    it "encerra a sessão e redireciona para a página de login" do
      post '/login', params: { login: 'arrascaeta@unb.br', password: 'senha_segura' }
      delete '/logout'
      expect(response).to redirect_to(login_path)
    end
  end
end