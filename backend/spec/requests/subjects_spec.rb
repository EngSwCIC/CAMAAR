require 'rails_helper'

RSpec.describe "Subjects", type: :request do
  before(:each) do
    load "#{Rails.root}/db/seeds.rb" 
  end

  describe "GET /" do
    it "returns http success" do
      get "/subjects"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /:id" do
    it "returns http success" do
      get "/subjects/1"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /admin_report" do
    let(:materia_1) { create(:subject, code: "#{rand(1000000)}", name: "#{rand(1000000)}") }
    let(:class_1) { create(:cclass, subject: materia_1) }
    let(:class_2) { create(:cclass, subject: materia_1, code: 'oi') }
    let(:class_3) { create(:cclass, code: 'tchau') }
    before do
      create(:enrollment, cclass: class_1, grade: 10)
      create(:enrollment, cclass: class_1, grade: 20)
      create(:enrollment, cclass: class_1, grade: 30)
      create(:enrollment, cclass: class_2, grade: 40)
      create(:enrollment, cclass: class_2, grade: 50)
      create(:enrollment, cclass: class_2, grade: 60)
      create(:enrollment, cclass: class_3, grade: 70)
    end
    
    it "should be ok" do
      get '/admin_report'
      expect(response).to have_http_status :ok
    end
  end

end
