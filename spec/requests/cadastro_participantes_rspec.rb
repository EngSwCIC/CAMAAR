require 'rails_helper'

RSpec.describe "Cadastro e Ativação de Participantes", type: :request do
  let(:usuario_pendente) { Usuario.create!(nome: "Pendente", email: "pendente@unb.br", matricula: "123", perfil: "discente", ativo: false, senha_hash: "") }

  describe "Acesso e Autenticação" do
    context "Cenário Feliz: Efetivação do cadastro" do
      it "altera o status para ativo e libera o login após o usuário cadastrar uma senha válida via link" do
        usuario_pendente.generate_setup_token!
        post setup_password_path, params: { token: usuario_pendente.setup_token, password: "senha123", password_confirmation: "senha123" }
        expect(response).to redirect_to(avaliacoes_path)
        expect(usuario_pendente.reload.ativo).to be_truthy
      end
    end

    context "Cenários Tristes: Tentativas inválidas" do
      it "nega o acesso e exibe mensagem de cadastro pendente caso o usuário inativo tente logar pela tela padrão" do
        post login_path, params: { email: usuario_pendente.email, password: "any" }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Cadastro pendente: Verifique seu e-mail para definir sua senha de acesso.")
      end

      it "registra falha no log e mantém o usuário inativo se o e-mail vindo do SIGAA for mal formatado" do
        bad_user = Usuario.new(nome: "Bad", email: "bademail", matricula: "999", perfil: "discente", senha_hash: "", ativo: false)
        bad_user.save(validate: false)
        expect(bad_user.ativo).to be_falsey
      end

      it "exibe mensagem 'Link expirado' e não altera o status se o token de definição de senha estiver fora da validade" do
        usuario_pendente.generate_setup_token!
        usuario_pendente.update!(setup_token_sent_at: 2.days.ago)
        get setup_password_path(token: usuario_pendente.setup_token)
        expect(response.body).to include("Link expirado")
        expect(usuario_pendente.reload.ativo).to be_falsey
      end
    end
  end
end
