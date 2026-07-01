require 'rails_helper'

RSpec.describe 'Users::Passwords', type: :request do
  let!(:user) do
    User.create!(
      name: 'Usuário Teste',
      email: 'usuario@unb.br',
      password: 'senha123',
      role: 'user'
    )
  end

  describe 'POST /users/password (solicitar redefinição)' do
    context 'Caminho Feliz' do
      it 'envia email de redefinição para email válido' do
        post '/users/password', params: {
          user: { email: 'usuario@unb.br' }
        }, as: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('E-mail de redefinição de senha enviado com sucesso.')
      end

      it 'envia o email com o token de redefinição' do
        expect {
          post '/users/password', params: { user: { email: 'usuario@unb.br' } }, as: :json
        }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end

    context 'Caminho Triste' do
      it 'retorna erro para email não cadastrado' do
        post '/users/password', params: {
          user: { email: 'inexistente@unb.br' }
        }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to eq('E-mail não encontrado.')
      end
    end
  end

  describe 'PUT /users/password (redefinir com token)' do
    let(:raw_token) { user.send_reset_password_instructions }

    context 'Caminho Feliz' do
      it 'redefine a senha com token válido' do
        put '/users/password', params: {
          user: {
            reset_password_token: raw_token,
            password: 'novasenha123',
            password_confirmation: 'novasenha123'
          }
        }, as: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Senha redefinida com sucesso.')
      end

      it 'permite login com a nova senha após redefinição' do
        put '/users/password', params: {
          user: {
            reset_password_token: raw_token,
            password: 'novasenha123',
            password_confirmation: 'novasenha123'
          }
        }, as: :json

        post '/users/sign_in', params: {
          user: { login: 'usuario@unb.br', password: 'novasenha123' }
        }, as: :json

        expect(response).to have_http_status(:ok)
      end
    end

    context 'Caminho Triste' do
      it 'retorna erro com token inválido' do
        put '/users/password', params: {
          user: {
            reset_password_token: 'token_invalido',
            password: 'novasenha123',
            password_confirmation: 'novasenha123'
          }
        }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to eq('Token inválido ou expirado.')
      end

      it 'retorna erro quando senhas não coincidem' do
        put '/users/password', params: {
          user: {
            reset_password_token: raw_token,
            password: 'novasenha123',
            password_confirmation: 'senhadiferente'
          }
        }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end