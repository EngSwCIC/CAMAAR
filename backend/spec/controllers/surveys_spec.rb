require 'rails_helper'
require 'json'

RSpec.describe SurveysController, type: :controller do

  describe "GET #index" do
    before(:each) do
      @fake_results = [instance_double('Survey'), instance_double('Survey')]
    end

    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end

    it 'should call the Model method that returns all surveys' do
      expect(Survey).to receive(:find).with('1')
      get :show, params: { id: '1' }
    end

    it 'it is assigning all surveys created to the right variable' do
      allow(Survey).to receive(:all).and_return(@fake_results)
      get :index
      expect(assigns(:surveys)).to eq(@fake_results)
    end

    it "is returning all surveys created in json format" do
      allow(Survey).to receive(:all).and_return(@fake_results)

      get :index
      expected_output = @fake_results.map { |element| element.as_json }
      output = (JSON.parse(response.body))

      expect(output).to eq(expected_output)
    end
  end


  describe 'method show' do
    before(:each) do
      @survey1 = instance_double('Survey')
      allow(@survey1).to receive(:role_id).and_return(1)
      @survey2 = instance_double('Survey')
      allow(@survey2).to receive(:role_id).and_return(2)

      @surveys = [@survey1, @survey2]

      allow(Survey).to receive(:find).with('1').and_return(@surveys[0])
    end

    it 'should have status 200' do
      expect(Survey).to receive(:find).with('1')
      get :show, params: { id: '1' }
      expect(response).to be_successful
    end

    it 'should call the Model method that finds by id' do
      expect(Survey).to receive(:find).with('1')
      get :show, params: { id: '1' }
    end

    it 'it is assigning the right survey to the right variable' do
      get :show, params: { id: '1' }
      expect(assigns(:survey)).to eq(@surveys[0])
    end

    it 'should render the right survey' do
      get :show, params: { id: '1' }

      expected_output = @surveys[0].as_json
      output = (JSON.parse(response.body))

      expect(output).to eq(expected_output)
    end
  end
end