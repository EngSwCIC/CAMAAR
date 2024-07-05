require 'rails_helper'

RSpec.describe ImportDataController, type: :controller do
  describe 'POST #create' do
    context 'with valid JSON file' do
      let(:file) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'data.json'), 'application/json') }

      it 'imports participants and returns success' do
        post :create, params: { file: file }

        expect(response).to have_http_status(:ok)
        expect(response).to have_json_type(Object).at_path('message')
        expect(JSON.parse(response.body)['message']).to eq('Participantes importados com sucesso')
      end

      it 'creates users with unique password reset links' do
        expect {
          post :create, params: { file: file }
        }.to change(User, :count).by(1)

        user = User.last
        expect(user.nome).to eq('João Silva')
        expect(user.email).to eq('joao.silva@example.com')
        expect(user.reset_password_token).not_to be_nil
        expect(user.reset_password_sent_at).not_to be_nil
      end
    end

    context 'with missing file' do
      it 'returns bad request status' do
        post :create

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['message']).to eq('Arquivo não enviado')
      end
    end
  end
end
