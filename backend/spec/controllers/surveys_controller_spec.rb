require 'rails_helper'

RSpec.describe SurveysController, type: :controller do
  let(:survey) do
    Survey.new({
                 "name": 'Questionário',
                 "description": 'Descrição teste',
                 "expiration_date": '',
                 "semester": '2022/2',
                 "role_id": 1
               })
  end

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

  describe('#show') do
    describe('when the survey is not found') do
      before(:each) do
        allow(Survey).to receive(:find).and_return(nil)
        get :show, params: { id: 1 }
      end

      it 'renders the not found survey error message' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(JSON.parse(response.body)).to eq({ error: 'Survey not found' }.as_json)
      end

      it 'returns a 404 error code' do
        expect(response).to have_http_status(:not_found)
        expect(response.status).to eq(404)
      end
    end

    describe('when the survey is found') do
      before(:each) do
        allow(Survey).to receive(:find).and_return(survey)
        get :show, params: { id: 1 }
      end

      it('renders the found survey') do
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(JSON.parse(response.body)).to eq(survey.as_json)
      end

      it('returns an ok status') do
        expect(response).to have_http_status(:ok)
        expect(response.status).to eq(200)
      end
    end
  end

  describe('#index') do
    describe('when the surveys are found') do
      let(:surveys) do
        (1..10).map { survey }
      end

      before(:each) do
        allow(Survey).to receive(:all).and_return(
          surveys
        )

        get :index
      end

      it('renders the found surveys') do
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(JSON.parse(response.body)).to eq(surveys.as_json)
      end

      it('returns an ok status') do
        expect(response).to have_http_status(:ok)
        expect(response.status).to eq(200)
      end
    end

    describe('when the surveys are not found') do
      let(:surveys) { [] }

      before(:each) do
        allow(Survey).to receive(:all).and_return(surveys)

        get :index
      end

      it('renders an empty array') do
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(JSON.parse(response.body)).to eq(surveys.as_json)
      end

      it('returns an ok status') do
        expect(response).to have_http_status(:ok)
        expect(response.status).to eq(200)
      end
    end
  end
end
