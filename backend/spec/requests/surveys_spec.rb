require 'rails_helper'

RSpec.describe "Surveys", type: :request do
  context "GET #index" do
    it 'should success and render filtration page' do
      get '/index', params: {}
      expect(assigns(:surveys)).to_not be_empty
    end
  end
end
