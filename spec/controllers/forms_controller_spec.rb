require 'rails_helper'

RSpec.describe FormulariosController, type: :request do
  
  describe 'GET #get_response_files' do
    it 'Retorna os arquivos de resposta corretos' do
      form_name = 'eng_software'
      question_key = 'eng_software'

      get '/get_response_files', params: { form_name: form_name, question_key: question_key }

      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('responses')
    end
  end

  describe 'GET #count_responses' do
    it 'Conta as respostas corretamente' do
      form_name = 'eng_software'
      professor = 'eng_software'
      semester = 'eng_software'

      get '/count_responses', params: { form_name: form_name, professor: professor, semester: semester }
  
      expect(response).to have_http_status(:success)
  
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('totalResponses')
    end
  end
end