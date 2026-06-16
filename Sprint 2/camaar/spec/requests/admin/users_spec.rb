require 'rails_helper'

RSpec.describe 'Admin::Users', type: :request do
  let!(:admin) do
    User.create!(
      name: 'Administrador',
      email: 'admin@unb.br',
      password: 'admin123',
      role: 'admin',
      department: 'CIC'
    )
  end

  let(:sigaa_data) do
    [
      {
        code: 'CIC0097',
        classCode: 'TA',
        semester: '2021.2',
        docente: {
          nome: 'MARISTELA TERTO DE HOLANDA',
          departamento: 'DEPTO CIÊNCIAS DA COMPUTAÇÃO',
          formacao: 'DOUTORADO',
          usuario: '83807519491',
          email: 'mholanda@unb.br',
          ocupacao: 'docente'
        },
        dicente: [
          {
            nome: 'Ana Clara Jordao Perna',
            curso: 'CIÊNCIA DA COMPUTAÇÃO/CIC',
            matricula: '190084006',
            usuario: '190084006',
            formacao: 'graduando',
            ocupacao: 'dicente',
            email: 'acjpjvjp@gmail.com'
          },
          {
            nome: 'Andre Carvalho de Roure',
            curso: 'CIÊNCIA DA COMPUTAÇÃO/CIC',
            matricula: '200033522',
            usuario: '200033522',
            formacao: 'graduando',
            ocupacao: 'dicente',
            email: 'andreCarvalhoroure@gmail.com'
          }
        ]
      }
    ]
  end

  describe 'POST /admin/users/import' do
    context 'Caminho Feliz - admin autenticado' do
      before { sign_in admin }

      it 'importa docente e dicentes com sucesso' do
        post '/admin/users/import', params: { data: sigaa_data }, as: :json

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body['criados']).to eq(3)
        expect(body['ignorados']).to eq(0)
        expect(body['erros']).to be_empty
      end

      it 'cria o professor como admin' do
        post '/admin/users/import', params: { data: sigaa_data }, as: :json

        professor = User.find_by(email: 'mholanda@unb.br')
        expect(professor).not_to be_nil
        expect(professor.role).to eq('admin')
        expect(professor.department).to eq('CIC')
        expect(professor.matricula).to eq('83807519491')
      end

      it 'cria os alunos como user' do
        post '/admin/users/import', params: { data: sigaa_data }, as: :json

        aluno = User.find_by(email: 'acjpjvjp@gmail.com')
        expect(aluno).not_to be_nil
        expect(aluno.role).to eq('user')
        expect(aluno.department).to eq('CIC')
        expect(aluno.matricula).to eq('190084006')
      end

      it 'ignora usuários já cadastrados' do
        User.create!(
          name: 'Ana Clara Jordao Perna',
          email: 'acjpjvjp@gmail.com',
          matricula: '190084006',
          password: 'senha123',
          role: 'user'
        )

        post '/admin/users/import', params: { data: sigaa_data }, as: :json

        body = JSON.parse(response.body)
        expect(body['criados']).to eq(2)
        expect(body['ignorados']).to eq(1)
      end

      it 'envia email de definição de senha para novos usuários' do
        expect {
          post '/admin/users/import', params: { data: sigaa_data }, as: :json
        }.to change(ActionMailer::Base.deliveries, :count).by(3)
      end

      it 'retorna erro para formato inválido' do
        post '/admin/users/import', params: { data: 'invalido' }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'Caminho Triste - sem autenticação ou sem permissão' do
      it 'rejeita usuário não autenticado' do
        post '/admin/users/import', params: { data: sigaa_data }, as: :json

        expect(response).to have_http_status(:redirect)
      end

      it 'rejeita usuário comum (não admin)' do
        user_comum = User.create!(
          name: 'Usuário Comum',
          email: 'comum@unb.br',
          password: 'senha123',
          role: 'user'
        )
        sign_in user_comum

        post '/admin/users/import', params: { data: sigaa_data }, as: :json

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end
end