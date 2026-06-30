require 'rails_helper'

RSpec.describe "SenhaController", type: :request do
  let(:usuario) { create(:usuario, password: 'OldPass1', password_confirmation: 'OldPass1') }

  before do
    post login_path, params: { email: usuario.email, password: 'OldPass1' }
    follow_redirect!
  end

  describe "POST /senha/redefinir" do
    context "Com senha antiga correta e as duas novas senhas iguais" do
      it "updates password and shows no alert" do
        post senha_redefinir_path, params: {
          password: 'OldPass1',
          new_password_1: 'NewPass1',
          new_password_2: 'NewPass1'
        }
        expect(flash[:alert]).to be_nil
        expect(usuario.reload.authenticate('NewPass1')).to be_truthy
      end
    end

    context "Com senha errada" do
      it "Manda um aviso e não muda a senha" do
        post senha_redefinir_path, params: {
          password: 'WrongPass1',
          new_password_1: 'NewPass1',
          new_password_2: 'NewPass1'
        }
        expect(flash[:alert]).to include("Senha antiga")
        expect(usuario.reload.authenticate('OldPass1')).to be_truthy
      end
    end

    context "Novas senhas diferentes" do
      it "sets alert and does not change password" do
        post senha_redefinir_path, params: {
          password: 'OldPass1',
          new_password_1: 'NewPass1',
          new_password_2: 'Mismatch1'
        }
        expect(flash[:alert]).to eq("As senhas não são as mesmas")
        expect(usuario.reload.authenticate('OldPass1')).to be_truthy
      end
    end

    context "Nova senha não atende aos requisitos mínimos (Sad Path)" do
      it "renderiza a view com erro de validação e não altera a senha" do
        post senha_redefinir_path, params: {
          password: 'OldPass1',
          new_password_1: 'abc',
          new_password_2: 'abc'
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(usuario.reload.authenticate('OldPass1')).to be_truthy
      end
    end
  end

  describe "POST /senha/recuperar" do
    context "com e-mail de usuário cadastrado (Happy Path)" do
      it "gera o token e redireciona com aviso de envio" do
        post recuperar_senha_path, params: { email: usuario.email }
        expect(response).to redirect_to(recuperar_senha_path)
        follow_redirect!
        expect(response.body).to include("instruções")
      end
    end

    context "com e-mail não cadastrado (Sad Path)" do
      it "redireciona com o mesmo aviso sem revelar a existência do e-mail" do
        post recuperar_senha_path, params: { email: "nao-existe@example.com" }
        expect(response).to redirect_to(recuperar_senha_path)
        follow_redirect!
        expect(response.body).to include("instruções")
      end
    end
  end
end
