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
      survey = Survey.create! valid_attributes
      get survey_url(survey), as: :json
      expect(response).to be_successful

      parsed_res = JSON.parse(response.body)
      expect(parsed_res['id']).to eql survey.id
    end
  end
end
