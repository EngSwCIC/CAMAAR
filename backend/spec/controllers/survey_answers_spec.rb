require 'rails_helper'
require 'json'

RSpec.describe SurveyAnswersController, type: :controller do
  describe "POST #create" do
    before(:each) do
      @invalid_params = {"survey_id"=>1, "cclass_id"=>1, "member_id"=>1, "answers_attributes"=>[{"question_type"=>{"name"=>"discursive"}, "content"=>nil}, {"question_type"=>{"name"=>"multiple_choice"}, "content"=>nil}, {"survey_question_id"=> 3, "question_type"=>{"name"=>"likert_scale"}, "likert_answers_attributes"=>[{"likert_question_id"=>1, "content"=>nil}, {"likert_question_id"=>2, "content"=>nil}, {"likert_question_id"=>3, "content"=>nil}, {"likert_question_id"=>4, "content"=>nil}, {"likert_question_id"=>5, "content"=>nil}, {"likert_question_id"=>6, "content"=>nil}, {"likert_question_id"=>7, "content"=>nil}, {"likert_question_id"=>8, "content"=>nil}, {"likert_question_id"=>9, "content"=>nil}, {"likert_question_id"=>10, "content"=>nil}, {"likert_question_id"=>11, "content"=>nil}, {"likert_question_id"=>12, "content"=>nil}]}], "survey_answer"=>{"survey_id"=>1, "member_id"=>1, "cclass_id"=>1}}

      @valid_params = {"survey_id"=>1, "cclass_id"=>1, "member_id"=>1, "answers_attributes"=>[{"question_type"=>{"name"=>"discursive"}, "content"=>nil}, {"question_type"=>{"name"=>"multiple_choice"}, "content"=>0}, {"survey_question_id"=>3, "question_type"=>{"name"=>"likert_scale"}, "likert_answers_attributes"=>[{"likert_question_id"=>1, "content"=>"Discordo totalmente"}, {"likert_question_id"=>2, "content"=>"Discordo totalmente"}, {"likert_question_id"=>3, "content"=>"Discordo totalmente"}, {"likert_question_id"=>4, "content"=>"Discordo totalmente"}, {"likert_question_id"=>5, "content"=>"Discordo totalmente"}, {"likert_question_id"=>6, "content"=>"Discordo totalmente"}, {"likert_question_id"=>7, "content"=>"Discordo totalmente"}, {"likert_question_id"=>8, "content"=>"Discordo totalmente"}, {"likert_question_id"=>9, "content"=>"Discordo totalmente"}, {"likert_question_id"=>10, "content"=>"Discordo totalmente"}, {"likert_question_id"=>11, "content"=>"Discordo totalmente"}, {"likert_question_id"=>12, "content"=>"Discordo totalmente"}]}], "survey_answer"=>{"survey_id"=>1, "member_id"=>1, "cclass_id"=>1}}

      @invalid_survey_answer = double("SurveyAnswer", @invalid_params)

      @valid_survey_answer =  double("SurveyAnswer", @valid_params)
    end

    context "when the survey answer is successfully created" do
      before do
        allow(SurveyAnswer).to receive(:new).and_return(@valid_survey_answer)
        allow(@valid_survey_answer).to receive(:save).and_return(true)
      end

      it "returns a JSON response with the survey answer" do
        post :create, params: @valid_params
        expect(response).to have_http_status(:success)
        expect(response.body).to eq @valid_survey_answer.to_json
      end
    end

    context "when the survey answer fails to save" do
      before do
        allow(SurveyAnswer).to receive(:new).and_return(@invalid_survey_answer)
        allow(@invalid_survey_answer).to receive(:save).and_return(false)
        allow(@invalid_survey_answer).to receive(:errors).and_return({ content: ["can't be blank"] })
      end

      it "returns a JSON response with the errors" do
        post :create, params: @invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq @invalid_survey_answer.errors.to_json
      end
    end
  end
end