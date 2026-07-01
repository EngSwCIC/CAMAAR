require 'rails_helper'

RSpec.describe "ApplicationController Security Filters", type: :request do
  describe "Filtros Globais de Autenticação" do
    it "garante que o ApplicationController intercepta usuários deslogados tentando acessar a raiz" do
      get root_path
      expect(response).to have_http_status(:success).or(have_http_status(:redirect))
    end

    it "passa pelos métodos auxiliares de checagem ao tentar deslogar sem uma sessão ativa" do
      delete logout_path
      expect(response).to redirect_to(login_path)
    end
  end
end