require 'rails_helper'

RSpec.describe SurveysController, type: :controller do
  describe '#show_answers' do
    let(:survey) { create(:survey) }
    let!(:question_answers) { create_list(:question_answer, 3, survey: survey) }

    it 'returns the question answers for a given survey' do
      get "/surveys/1/answers"

      expect(response).to be_successful
      expect(response.content_type).to eq('application/json')
      expect(response.body).to eq(question_answers.to_json)
    end

    it 'returns a 404 status code if the survey is not found' do
      get "/surveys/1/answers"

      expect(response).to have_http_status(:not_found)
    end
  end
end
