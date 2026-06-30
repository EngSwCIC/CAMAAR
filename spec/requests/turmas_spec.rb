require 'rails_helper'

RSpec.describe "Turmas", type: :request do
  include Devise::Test::IntegrationHelpers

  describe "GET /turmas" do
    
    context "quando o usuário está logado (Happy Path)" do
      let(:user) { User.create!(email: "aluno@unb.br", password: "password123", nome: "Aluno", matricula: "123456", perfil: "discente") }

      it "acessa a página de turmas com sucesso" do
        sign_in user
        get "/turmas"
        expect(response).to have_http_status(:success)
      end
    end

    context "quando o usuário não está logado (Sad Path)" do
      it "bloqueia o acesso e redireciona para a tela de login" do
        # Fazemos a requisição direto, sem usar o sign_in antes
        get "/turmas"
        
        # O sistema deve barrar e jogar para o login (status 302 Redirect)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end
end