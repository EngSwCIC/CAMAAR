require 'rails_helper'

json_txt = '{
  "id": "1",
  "name": "Questionário 1",
  "description": "this is a test survey",
  "role_id": 2,
  "expiration_date": "Thu, 21 Jun 2028 12:15:50 -0300",
  "semester": "2021/2"
}'

RSpec.describe SurveysController, type: :controller do
  describe "GET #index" do
    it "returns a success response" do
      survey = Survey.create
      get :index
      expect(response).to be_successful
    end

    it "esta retornando todos os surveys" do
      survey = Survey.new(JSON.parse(json_txt))
      allow(Survey).to receive(:all).and_return(survey)

      get :index
      expect(response.body).to eq("{\"id\":1,\"name\":\"Questionário 1\",\"description\":\"this is a test survey\",\"expiration_date\":\"2028-06-21T15:15:50.000Z\",\"semester\":\"2021/2\",\"survey_questions\":[]}")
    end
  end
end



