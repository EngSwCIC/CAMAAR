require 'rails_helper'

RSpec.describe SurveysController, type: :controller do
  describe('#create') do
    it 'creates a new survey and return success' do
      surver_params = {
        "name": 'Questionário',
        "description": 'Descrição teste',
        "expiration_date": '',
        "semester": '2022/2',
        "role_id": 1
      }
      survey = Survey.new(surver_params)

      allow(Survey).to receive(:new).and_return(survey)

      get :create, params: { survey: surver_params }

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)).to eq(survey.as_json)
    end
  end
end
