require 'rails_helper'

RSpec.describe "Answers", type: :request do
  describe "GET /index" do
    it "assigns @answers" do
      answer = Answer.create
      get :index
      expect(assigns(:answers)).to eq([answer])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end
end
