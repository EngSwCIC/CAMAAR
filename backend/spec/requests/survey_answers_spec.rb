require 'rails_helper'

RSpec.describe "/survey_answers", type: :request do

  before(:each) {
    @subject = Subject.where(code: 'CIC0097', name: 'BANCO DE DADOS').first_or_create
    @cclass = Cclass.where(code: 'TA', semester: '2021/2', time: '35T45', subject: @subject).first_or_create
    @member = Member.create(
      name: 'teste',
      registration: Random.rand(1000000).to_s,
      username: 'teste',
      occupation: 'dicente',
      degree: 'graduando',
      course: 'teste',
      email: 'email@email.com',
    )
    @survey = Survey.create(name: 'teste', description: 'teste', expiration_date: Time.new, semester: '2021/2')
    @discursive = SurveyQuestion.create(question: 'teste', question_type: 'discursive', optional: false, survey: @survey)
  }

  let(:valid_attributes) {{
    survey_id: @survey.id,
    cclass_id: @cclass.id,
    member_id: @member.id,
    answers_attributes: [{
      content: 'resposta',
      survey_question_id: @discursive.id,
      question_type: @discursive.question_type
    }]
  }}

  let(:invalid_attributes) {{
    survey_id: @survey.id,
    cclass_id: @cclass.id,
    member_id: @member.id,
    answers_attributes: [{
      content: nil,
      survey_question_id: @discursive.id,
      question_type: @discursive.question_type
    }]
  }}

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new SurveyAnswer" do
        expect {
          post survey_answers_url,
               params: { survey_answer: valid_attributes }, as: :json
        }.to change(SurveyAnswer, :count).by(1)
      end

      it "renders a JSON response with the new survey_answer" do
        post survey_answers_url,
             params: { survey_answer: valid_attributes }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new SurveyAnswer" do
        expect {
          post survey_answers_url,
               params: { survey_answer: invalid_attributes }, as: :json
        }.to change(SurveyAnswer, :count).by(0)
      end

      it "renders a JSON response with errors for the new survey_answer" do
        post survey_answers_url,
             params: { survey_answer: invalid_attributes }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested survey_answer" do
        survey_answer = SurveyAnswer.create! valid_attributes
        patch survey_answer_url(survey_answer),
              params: { survey_answer: new_attributes }, as: :json
        survey_answer.reload
        skip("Add assertions for updated state")
      end

      it "renders a JSON response with the survey_answer" do
        survey_answer = SurveyAnswer.create! valid_attributes
        patch survey_answer_url(survey_answer),
              params: { survey_answer: new_attributes }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the survey_answer" do
        survey_answer = SurveyAnswer.create! valid_attributes
        patch survey_answer_url(survey_answer),
              params: { survey_answer: invalid_attributes }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end
end
