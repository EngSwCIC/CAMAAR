require 'rails_helper'

# RSpec.describe SurveysController, type: :controller do
#   describe '#show_answers' do
#     let(:survey) { create(:survey) }
#     let!(:question_answers) { create_list(:question_answer, 3, survey: survey) }

#     it 'returns the question answers for a given survey' do
#       get "/surveys/#{survey.id}/answers"

#       expect(response).to be_successful
#       expect(response.content_type).to eq('application/json')
#       expect(response.body).to eq(question_answers.to_json)
#     end

#     it 'returns a 404 status code if the survey is not found' do
#       get "/surveys/#{survey.id}/answers"

#       expect(response).to have_http_status(:not_found)
#     end
#   end
# end

  RSpec.describe SurveysController, type: :request do

    describe "GET #show_answers" do
      it "returns http ok" do
        @r = create(:role)
        @survey = create(:survey)
        get "/surveys/1/answers"
        expect(response).to have_http_status(:ok)
      end

      it "returns http ok 1" do
        @r = create(:role)
        @survey = create(:survey)
        @question_type = create(:question_type)
        @survey_question = create(:survey_question)
        @subject = create(:subject)
        @member = create(:member)
        @cclass = create(:cclass)
        @survey_answer = create(:survey_answer)
        puts @survey.id
        get "/surveys/#{@survey.id}/answers"
        data = JSON.parse(response.body)
        expect(data.length()).to equal(0)
      end
    end
  end 
