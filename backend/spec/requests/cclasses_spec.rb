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
      before do
        Member.destroy_all
        Cclass.destroy_all
        MemberCclass.destroy_all

        create(:member, name: 'Joaquias', id: 1)
        create(:member, name: 'Jonas', id: 2)
        create(:member, name: 'João', id: 3)
        let(:cclass) {create(:cclass)}
        create(:member_cclass, member_id: 1, cclass_id: 1, grade: 0)
        create(:member_cclass, member_id: 2, cclass_id: 1, grade: 100)
        create(:member_cclass, member_id: 3, cclass_id: 1, grade: 50)

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
      before do
        Member.destroy_all
        Cclass.destroy_all
        MemberCclass.destroy_all

        create(:member, name: 'Bruno', id: 1)
        create(:member, name: 'Bernardo', id: 2)
        create(:member, name: 'Bisquela', id: 3)
        let(:cclass) {create(:cclass)}
        create(:member_cclass, member_id: 1, cclass_id: 1, grade: nil)
        create(:member_cclass, member_id: 2, cclass_id: 1, grade: nil)
        create(:member_cclass, member_id: 3, cclass_id: 1, grade: nil)

        get "/cclass_grade/#{cclass.id}"
      end

      it "Should return ok http status" do
        expect(response).to have_http_status(:ok)
      end

      it "Should treat nil as zero and return zero grade" do
        expect(JSON.parse(response.body)).to eq(0)
      end
    end

    context "When request has invalid/missing cclass_id" do
      before do
        Member.destroy_all
        Cclass.destroy_all
        MemberCclass.destroy_all

        create(:member, name: 'Samuel', id: 1)
        create(:member, name: 'Samira', id: 2)
        create(:member, name: 'Sofia', id: 3)
        create(:member_cclass, member_id: 1, cclass_id: 1, grade: 60)
        create(:member_cclass, member_id: 2, cclass_id: 1, grade: 40)
        create(:member_cclass, member_id: 3, cclass_id: 1, grade: 30)

        get "/cclass_grade/1"
      end

      it "Should return bad_request http status" do
        expect(response).to have_http_status(:bad_request)
      end
    end

  end

end

end
