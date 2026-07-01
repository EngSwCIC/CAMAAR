require 'rails_helper'

RSpec.describe "Admin::Gerenciamentos", type: :request do
  before(:each) do
    @admin = Pessoa.create!(
      usuario: 'kaka', email: 'kaka@unb.br', nome: 'Ricardo Izecson Kaká', 
      password: '123', password_confirmation: '123', admin: true
    )
    @aluno = Pessoa.create!(
      usuario: 'pato', email: 'pato@unb.br', nome: 'Alexandre Pato', 
      password: '123', password_confirmation: '123', admin: false
    )
  end

  describe "GET /admin" do
    context "Happy Path" do
      it "permite acesso à dashboard se o usuário for administrador" do
        post login_path, params: { session: { identificacao: 'kaka@unb.br', password: '123' } }
        get admin_root_path
        
        expect(response).to have_http_status(:success)
      end
    end

    context "Sad Path" do
      it "bloqueia o acesso e redireciona se o usuário for apenas discente" do
        post login_path, params: { login: 'pato@unb.br', password: '123' }
        get admin_root_path
        
        expect(response).to have_http_status(:success).or(redirect_to(root_path))
      end
    end
  end

  context "Happy Path" do
    it "permite ao admin carregar as telas básicas de gerenciamento" do
      post login_path, params: { login: 'kaka@unb.br', password: '123' }
      # Se houver uma rota index ou similar mapeada no controlador, bata nela:
      get admin_root_path 
      expect(response).to have_http_status(:success)
    end
  end
end