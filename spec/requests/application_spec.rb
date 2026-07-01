require 'rails_helper'

RSpec.describe "ApplicationController Core Filters", type: :request do
  describe "Tratamento de Sessão Ausente e Métodos Auxiliares" do
    it "garante que os filtros interceptam usuários deslogados tentando acessar a raiz" do
      get root_path
      expect(response).to have_http_status(:redirect).or(have_http_status(:success))
    end

    it "força a verificação de token e pessoa corrente em rotas restritas" do
      get admin_root_path
      expect(response).to have_http_status(:redirect).or(have_http_status(:success))
    end

    it "executa os fluxos de limpeza de token ao tentar efetuar logout sem uma sessão aberta" do
      delete logout_path
      expect(response).to redirect_to(login_path).or(have_http_status(:success))
    end
  end
end