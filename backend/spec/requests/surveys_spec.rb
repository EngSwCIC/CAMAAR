require 'rails_helper'

RSpec.describe "/surveys", type: :request do

  let(:valid_attributes) {{
    name: 'name',
    description: 'desc',
    expiration_date: 2.hours.from_now,
    semester: '2021/2',
  }}

  let(:expired_attributes) {{
    name: 'name',
    description: 'desc',
    expiration_date: 2.hours.ago,
    semester: '2021/2',
  }}

  let(:invalid_attributes) {{
    description: 'desc',
    expiration_date: 2.hours.from_now,
    semester: '2021/2',
  }}

  describe "GET /index" do
    before { 
      5.times { Survey.create(valid_attributes)}
      5.times { Survey.create(expired_attributes)}
    }

    it "renders a successful response" do

      get surveys_url, as: :json
      expect(response).to be_successful

      surveys = Survey.all
      parsed_res = JSON.parse(response.body)

      for entry, index in parsed_res do
        expect(entry['id']).to eql surveys[parsed_res.index(entry)].id
      end
    end
  end

  describe "GET /open" do
    before { 
      5.times { Survey.create(valid_attributes)}
      5.times { Survey.create(expired_attributes)}
    }

    it "renders a successful response" do

      get surveys_url + '/open', as: :json
      expect(response).to be_successful

      surveys = Survey.all.select do |survey|
        not survey.is_expired?
      end

      parsed_res = JSON.parse(response.body)
      for entry, index in parsed_res do
        expect(entry['id']).to eql surveys[parsed_res.index(entry)].id
      end
    end

  end

  describe "GET /show" do
    it "renders a successful response" do
      role = Role.create(name: 'role')
      survey = Survey.create! valid_attributes.merge(role_id: role.id)
      get surveys_url + '/show/' + survey.id.to_s, as: :json
      expect(response).to be_successful

      parsed_res = JSON.parse(response.body)
      expect(parsed_res['id']).to eql survey.id
    end
  end

  describe "GET /reports" do
    before(:each) do
      load "#{Rails.root}/db/seeds.rb" 
    end

    it "returns survey reports in 2021.2 semester" do
      get surveys_url + '/reports?semester=2021.2'
      response_body = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(response_body.length).to be > 0

      survey = response_body[0];
      expect(survey['semester']).to eq('2021.2')
      expect(survey).to have_key('id')
      expect(survey).to have_key('name')
    end
    
    it "returns survey reports with answers in 2021.1 semester" do
      get surveys_url + '/reports?semester=2021.2'
      response_body = JSON.parse(response.body)

      survey_questions = response_body[0]['survey_questions']
      expect(survey_questions.length).to be > 0

      likert_scale_questions = survey_questions[0]['likert_scale_questions']
      expect(likert_scale_questions.length).to be > 0
      expect(likert_scale_questions[0]['answers'].length).to be > 0
    end

    it "returns empty survey reports if there's no surveys on that semester" do
      get surveys_url + '/reports?semester=2000.2'
      response_body = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(response_body.length).to be 0
    end
  end
end
