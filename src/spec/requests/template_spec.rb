require 'rails_helper'

RSpec.describe "Templates", type: :request do
  describe "GET templates" do
    it "deve retornar sucesso, buscando todos os templates" do
      get templates_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST templates" do 
    before(:each) do
      @admin = User.create(email: "admin1@email.com", password: "senh@123", isAdmin: true)
      @questao1 = Questao.find_or_create_by(tipo: "dissertativa") 
      @questao2 = Questao.find_or_create_by(tipo: "multipla escolha") 
    end

    it "deve criar um template com questoes" do
      post templates_path, params: {
        template: {
          user_id: @admin.id,
          semestre: "2024/1",
          nome: "temp1",
          questoes_id: [@questao1.id, @questao2.id]
        }
      }

      expect(response).to redirect_to '/templates'
    end
    
    it "deve retornar erro quando tentar criar um template sem questoes" do
      post templates_path, params: {
        template: {
          user_id: @admin.id,
          semestre: "2024/1",
          nome: "temp1",
          questoes: []
        }
      }
  
      expect(response).to have_http_status(400) 
    end
  end
end
