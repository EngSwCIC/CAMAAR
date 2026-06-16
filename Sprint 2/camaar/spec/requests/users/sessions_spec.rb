require 'rails_helper'

RSpec.describe 'Users::Sessions', type: :request do
  let!(:user) do
    User.create!(
      name: 'Usuário Comum',
      email: 'aluno@unb.br',
      matricula: '190084006',
      password: 'senha123',
      role: 'user'
    )
  end

  let!(:admin) do
    User.create!(
      name: 'Administrador',
      email: 'admin@unb.br',
      matricula: '83807519491',
      password: 'admin123',
      role: 'admin',
      department: 'CIC'
    )
  end

  describe 'POST /users/sign_in' do
    context 'Caminho Feliz - login com credenciais válidas' do
      it 'autentica usuário pelo e-mail' do
        post '/users/sign_in', params: {
          user: { login: 'aluno@unb.br', password: 'senha123' }
        }, as: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Login realizado com sucesso.')
        expect(JSON.parse(response.body)['user']['role']).to eq('user')
      end

      it 'autentica usuário pela matrícula' do
        post '/users/sign_in', params: {
          user: { login: '190084006', password: 'senha123' }
        }, as: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['user']['email']).to eq('aluno@unb.br')
      end

      it 'autentica administrador pelo e-mail' do
        post '/users/sign_in', params: {
          user: { login: 'admin@unb.br', password: 'admin123' }
        }, as: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['user']['role']).to eq('admin')
        expect(JSON.parse(response.body)['user']['department']).to eq('CIC')
      end

      it 'autentica administrador pela matrícula' do
        post '/users/sign_in', params: {
          user: { login: '83807519491', password: 'admin123' }
        }, as: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['user']['role']).to eq('admin')
      end
    end

    context 'Caminho Triste - credenciais inválidas' do
      it 'retorna erro com senha incorreta' do
        post '/users/sign_in', params: {
          user: { login: 'aluno@unb.br', password: 'senhaErrada' }
        }, as: :json

        expect(response).to have_http_status(:unauthorized)
      end

      it 'retorna erro com login inexistente' do
        post '/users/sign_in', params: {
          user: { login: 'inexistente@unb.br', password: 'qualquersenha' }
        }, as: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /users/sign_out' do
    it 'realiza logout com sucesso' do
      post '/users/sign_in', params: {
        user: { login: 'aluno@unb.br', password: 'senha123' }
      }, as: :json

      delete '/users/sign_out', as: :json
      expect(response).to have_http_status(:ok)
    end
  end
end