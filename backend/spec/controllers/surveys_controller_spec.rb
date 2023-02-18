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

    # testa o método show_answers que retorna as respostas de um determinado questionário
    describe "GET #show_answers" do

      # testa se um questionário é retornado
      it "returns http ok" do
        @r = create(:role)
        @survey = create(:survey)
        @question_type = create(:question_type)
        @survey_question = create(:survey_question)
        @member = create(:member)
        @cclass = create(:cclass)
        @survey_answer = create(:survey_answer)
        get "/surveys/#{@survey.id}/answers"
        expect(response).to have_http_status(:ok)
      end
      
      # testa se um questionário vazio é retornado
      it "returns an empty object" do
        @r = create(:role)
        @survey = create(:survey)
        @question_type = create(:question_type)
        @survey_question = create(:survey_question)
        @member = create(:member)
        @cclass = create(:cclass)
        @survey_answer = create(:survey_answer)
        get "/surveys/#{@survey.id}/answers"
        data = JSON.parse(response.body)
        expect(data.length()).to equal(0)
      end

      # testa se um questionário é retornado com todas as chaves
      it "returns a complete survey" do
        @r = create(:role)
        @survey = create(:survey)
        @question_type = create(:question_type)
        @survey_question = create(:survey_question)
        @member = create(:member)
        @cclass = create(:cclass)
        @survey_answer = create(:survey_answer)
        get "/surveys/#{@survey.id}/answers"
        data = JSON.parse(response.body)

        keys_expected = ['id', 'answer', 'survey_answer_id', 'survey_question_id', 'created_at', 'updated_at']

        missing_key = false

        data.each do |obj|
          keys_expected.each do |key|
            unless obj.has_key?(key)
              missing_key = true
              break
            end
          end
        end
        expect(missing_key).to equal(false)
      end
    end

    # testa o metodo show que retorna um determinado questionário
    describe "GET #show" do
      it "returns http ok" do
          @r = create(:role)
          @survey = create(:survey)
          @question_type = create(:question_type)
          @survey_question = create(:survey_question)
          @member = create(:member)
          @cclass = create(:cclass)
          @survey_answer = create(:survey_answer)
          get "/surveys/#{@survey.id}"
          expect(response).to have_http_status(:ok)
        end
    end

    # testa o metodo que retorna todos os questionários do banco de dados
    describe "GET #index" do
      it "returns http ok" do
        @r = create(:role)
        @survey = create(:survey)
        @question_type = create(:question_type)
        @survey_question = create(:survey_question)
        @member = create(:member)
        @cclass = create(:cclass)
        @survey_answer = create(:survey_answer)
        get "/surveys"
        expect(response).to have_http_status(:ok)
      end
    end

    # testa o método que retorna todos os questionários não expirados
    describe "GET #open" do
      it "returns http ok" do
        @r = create(:role)
        @survey = create(:survey)
        @question_type = create(:question_type)
        @survey_question = create(:survey_question)
        @member = create(:member)
        @cclass = create(:cclass)
        @survey_answer = create(:survey_answer)
        get "/surveys/open"
        expect(response).to have_http_status(:ok)
      end
    end
  end

