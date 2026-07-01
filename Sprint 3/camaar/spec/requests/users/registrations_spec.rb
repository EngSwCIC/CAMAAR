require 'rails_helper'

RSpec.describe 'Users::Registrations', type: :request do
  let(:valid_params) do
    {
      user: {
        name: 'Usuário Novo',
        email: 'novo@unb.br',
        password: 'senha123',
        password_confirmation: 'senha123',
        role: 'user',
        department: 'CIC'
      }
    }
  end

  describe 'POST /users' do
    context 'Caminho Feliz - dados válidos' do
      it 'cria o usuário e retorna status 201' do
        post '/users', params: valid_params, as: :json

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['message']).to eq('Usuário cadastrado com sucesso.')
      end

      it 'retorna os dados do usuário criado' do
        post '/users', params: valid_params, as: :json

        body = JSON.parse(response.body)
        expect(body['user']['email']).to eq('novo@unb.br')
        expect(body['user']['name']).to eq('Usuário Novo')
        expect(body['user']['role']).to eq('user')
        expect(body['user']['department']).to eq('CIC')
      end

      it 'persiste o usuário no banco' do
        expect {
          post '/users', params: valid_params, as: :json
        }.to change(User, :count).by(1)
      end
    end

    context 'Caminho Triste - dados inválidos' do
      it 'retorna 422 quando o e-mail já está em uso' do
        User.create!(
          name: 'Existente',
          email: 'novo@unb.br',
          password: 'senha123',
          role: 'user'
        )

        post '/users', params: valid_params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body)
        expect(body['message']).to eq('Erro ao cadastrar usuário.')
        expect(body['errors']).not_to be_empty
      end

      it 'retorna 422 quando a senha e a confirmação não coincidem' do
        params = valid_params.deep_merge(user: { password_confirmation: 'outrasenha' })

        post '/users', params: params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).not_to be_empty
      end

      it 'retorna 422 quando o nome está ausente' do
        params = valid_params.deep_merge(user: { name: '' })

        post '/users', params: params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'não cria usuário quando os dados são inválidos' do
        params = valid_params.deep_merge(user: { email: '' })

        expect {
          post '/users', params: params, as: :json
        }.not_to change(User, :count)
      end
    end
  end
end
