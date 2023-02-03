require 'rails_helper'

RSpec.describe SurveysController, type: :request do
  before(:all) do
    Role.create(name: 'teste', description: 'teste') # This will have id 1
  end

  describe('#create') do
    describe 'when given valid input' do
      let(:input)  do
        {
          "name": 'Questionário',
          "description": 'Descrição teste',
          "expiration_date": '',
          "semester": '2022/2',
          "role_id": 1
        }
      end

      before(:each) do
        headers = { 'ACCEPT' => 'application/json' }
        post '/create_survey', params: { survey: input }, headers: headers
      end

      it 'creates survey and returns success' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('2022/2')
        expect(response.body).to include('Questionário')
        expect(response.body).to include('Descrição teste')
      end
    end

    describe 'when given invalid input' do
      let(:input)  do
        {
          survey: {
            name: "teste"
          }
      }
      end

      before(:each) do
        headers = { 'ACCEPT' => 'application/json' }
        post '/create_survey', params: { survey: input }, headers: headers
      end

      it 'doesnt creates the survey and returns an error' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
