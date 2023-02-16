require 'rails_helper'
require 'json'

RSpec.describe SurveyAnswersController, type: :controller do
  describe "POST #create" do
    let(:survey_answer) { instance_double(SurveyAnswer) }

    before do
      allow(SurveyAnswer).to receive(:new).and_return(survey_answer)
    end

    context "when the survey answer is successfully created" do
      before do
        allow(survey_answer).to receive(:save).and_return(true)
      end

      it "returns a JSON response with the survey answer" do
        post :create, params: { survey_answer: { survey_id: 1, member_id: 1, cclass_id: 1 } }
        expect(response).to have_http_status(:success)
        expect(response.body).to eq survey_answer.to_json
      end
    end

    context "when the survey answer fails to save" do
      before do
        allow(survey_answer).to receive(:save).and_return(false)
        allow(survey_answer).to receive(:errors).and_return({ content: ["can't be blank"] })
      end

      it "returns a JSON response with the errors" do
        post :create, params: { survey_answer: { survey_id: 1, member_id: 1, cclass_id: 1 } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq survey_answer.errors.to_json
      end
    end
  end
end




