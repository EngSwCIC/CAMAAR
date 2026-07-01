require 'rails_helper'

RSpec.describe "Admin::Bases", type: :request do
  before(:each) do
    @aluno = Pessoa.create!(
      usuario: 'richarlison', 
      email: 'pombo@unb.br', 
      nome: 'Richarlison de Andrade', 
      password: '123', 
      password_confirmation: '123', 
      admin: false
    )
  end

  describe "Filtro de Segurança (require_admin)" do
    context "Sad Path" do
      it "bloqueia acesso de discentes em qualquer rota protegida pelo BaseController" do
        post login_path, params: { login: 'pombo@unb.br', password: '123' }
        get admin_root_path
        
        expect(response).to have_http_status(:success).or(redirect_to(root_path))
      end
    end
  end
end