require 'rails_helper'

RSpec.describe UpdateDataController, type: :request do
  describe 'POST #update' do

    let(:admin) do
      User.create!(
        name:      'Admin',
        email:     'admin@unb.br',
        matricula: '100',
        role:      'admin',
        password:  '123456'
      )
    end

    context 'quando autenticado como admin' do
      before { sign_in admin }

      context 'caminho feliz' do
        before do
          allow(UpdateDataService).to receive(:update_all)
            .and_return({ success: true, message: 'Dados atualizados com sucesso' })
        end

        it 'redireciona para o dashboard com mensagem de sucesso' do
          post update_data_path

          expect(response).to redirect_to(dashboard_path)
          follow_redirect!
          expect(response.body).to include('Dados atualizados com sucesso')
        end
      end

      context 'caminho triste' do
        before do
          allow(UpdateDataService).to receive(:update_all)
            .and_return({ success: false, error: 'Arquivos não localizados' })
        end

        it 'redireciona para o dashboard com mensagem de erro' do
          post update_data_path

          expect(response).to redirect_to(dashboard_path)
          follow_redirect!
          expect(response.body).to include('Arquivos não localizados')
        end
      end
    end

    context 'quando não autenticado' do
      it 'redireciona para o login' do
        post update_data_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end
end