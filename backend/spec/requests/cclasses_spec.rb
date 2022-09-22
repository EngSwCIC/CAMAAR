require 'rails_helper'

RSpec.describe "Cclasses", type: :request do
  before(:each) do
    load "#{Rails.root}/db/seeds.rb" 
  end

  describe "GET /" do
    it "returns http success" do
      get "/cclasses"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /:id" do
    it "returns http success" do
      get "/cclasses/1"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /:id/members" do
    it "returns members list" do
      get "/cclasses/1/members"
      response_body = JSON.parse(response.body)
      expect(response_body[44]['name']).to eq('MARISTELA TERTO DE HOLANDA')
    end
  end

  describe "GET /cclass_grade/:id" do

    context "When class members are graded" do
      let(:member_1 ) { create(:member, name: 'Joaquias') }
      let(:member_2 ) { create(:member, name: 'Jonas') }
      let(:member_3 ) { create(:member, name: 'João') }
      let(:cclass) {create(:cclass)}
      before do

        create(:enrollment, member_id: member_1.id, cclass_id: cclass.id, grade: 0)
        create(:enrollment, member_id: member_2.id, cclass_id: cclass.id, grade: 100)
        create(:enrollment, member_id: member_3.id, cclass_id: cclass.id, grade: 50)

        get "/cclass_grade/#{cclass.id}"
      end

      it "Should return ok http status" do
        expect(response).to have_http_status(:ok)
      end

      it "Should return right calculation" do
        expect(JSON.parse(response.body)).to eq(50)
      end
    end

    context "When class members are not graded" do
      
      let(:member_1) { create(:member, name: 'Bruno') }
      let(:member_2) { create(:member, name: 'Bernardo') }
      let(:member_3) { create(:member, name: 'Bisquela') }
      let(:cclass) {create(:cclass)}
      before do
        create(:enrollment, member_id: member_1.id, cclass_id: cclass.id, grade: nil)
        create(:enrollment, member_id: member_2.id, cclass_id: cclass.id, grade: nil)
        create(:enrollment, member_id: member_3.id, cclass_id: cclass.id, grade: nil)

        get "/cclass_grade/#{cclass.id}"
      end

      it "Should return ok http status" do
        expect(response).to have_http_status(:ok)
      end

      it "Should treat nil as zero and return zero grade" do
        expect(JSON.parse(response.body)).to eq(0)
      end
    end

  end


end

