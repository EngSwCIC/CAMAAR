require 'rails_helper'

RSpec.describe "Passwords", type: :request do
  before(:each) do
    @pessoa = Pessoa.create!(
      usuario: '10203040',
      email: 'ronaldinho@unb.br',
      nome: 'Ronaldinho Gaúcho',
      password: 'senha_antiga',
      password_confirmation: 'senha_antiga',
      reset_password_token: 'token_magico_123',
      reset_password_sent_at: Time.current
    )
  end

  describe "GET /passwords/:id/edit" do
    context "Happy Path" do
      it "acessa a página de redefinição com um token válido" do
        get edit_password_path('token_magico_123')
        expect(response).to have_http_status(:success)
      end
    end

    context "Sad Path" do
      it "redireciona para login ao tentar acessar com um token inválido" do
        get edit_password_path('token_falso_404')
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq("Link inválido ou expirado.")
      end
    end
  end

  describe "PATCH /passwords/:id" do
    context "Happy Path" do
      it "atualiza a senha com sucesso e limpa o token de recuperação" do
        patch password_path('token_magico_123'), params: {
          pessoa: { password: 'nova_senha_bruxo', password_confirmation: 'nova_senha_bruxo' }
        }
        
        @pessoa.reload
        expect(@pessoa.reset_password_token).to be_nil
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to eq("Senha definida com sucesso! Agora você pode acessar o Camaar.")
      end
    end

    context "Sad Path" do
      it "falha ao atualizar se as senhas não coincidirem" do
        patch password_path('token_magico_123'), params: {
          pessoa: { password: 'nova_senha_bruxo', password_confirmation: 'senha_errada' }
        }
        
        expect(response).to have_http_status(:unprocessable_entity)
        @pessoa.reload
        expect(@pessoa.reset_password_token).not_to be_nil
      end
    end
  end
end