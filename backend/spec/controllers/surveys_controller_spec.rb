require 'rails_helper'

RSpec.describe SurveysController, type: :controller do
  describe('#create') do
    describe('when params are valid') do
      surver_params = {
        "name": 'Questionário',
        "description": 'Descrição teste',
        "expiration_date": '',
        "semester": '2022/2',
        "role_id": 1
      }

      it 'creates a new survey and return success' do
        survey = Survey.new(surver_params)

        allow(Survey).to receive(:new).and_return(survey)

        post :create, params: { survey: surver_params }

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(JSON.parse(response.body)).to eq(survey.as_json)
      end
    end

    describe('when params are invalid') do
      surver_params = {
        "name": 'Questionário',
        "description": 'Descrição teste',
        "expiration_date": '',
        "semester": '2022/2',
        "role_id": 1,
        "invalid_key": 'invalid_value'
      }

      it 'does not create a new survey and return error' do
        errors = { errors: 'Unable to create survey' }
        survey_double = double('Survey', save: false, errors: errors)

        allow(Survey).to receive(:new).and_return(survey_double)

        post :create, params: { survey: surver_params }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(JSON.parse(response.body)).to eq(errors.as_json)
      end
    end
  end
end
