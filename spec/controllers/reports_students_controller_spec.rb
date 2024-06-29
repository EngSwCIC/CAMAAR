require 'rails_helper'

RSpec.describe ReportsAlunosController, type: :request do

  describe 'GET #index' do
    it 'retorna a lista de reports_alunos e formularios' do
      get '/reports_alunos'

      expect(response).to have_http_status(:success)
      expect(assigns(:reports_alunos)).not_to be_nil
      expect(assigns(:formularios)).not_to be_nil
    end
  end

  describe 'GET #fetch_form' do
  
    context 'quando o arquivo existe' do
      it 'retorna o conteúdo do arquivo JSON' do
        file_name = 'eng_software.json'
        get '/fetch_form', params: { file_name: file_name }
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response).not_to be_nil
      end
    end
  
    context 'quando o arquivo não existe' do
      it 'retorna status 404 e mensagem de erro' do
        file_name = 'arquivo_inexistente.json'
        get '/fetch_form', params: { file_name: file_name }
        expect(response).to have_http_status(404)
        json_response = JSON.parse(response.body)
        expect(json_response).to include('error' => 'File not found')
      end
    end
  end
end