require 'rails_helper'

RSpec.describe "MemberCclasses", type: :request do
  describe "POST /create" do
    let(:member) {create(:member)}
    let(:cclass) {create(:cclass)}

    let(:valid_params) do {
      grade: 50,
      member_id: member.id,
      cclass_id: cclass.id
    }
    end
    let(:invalid_params) do {
      grade: -50,
      member_id: member.id,
      cclass_id: cclass.id
    }
    end
    context 'When using valid_params' do
      before do
        MemberCclass.destroy_all
        post '/member_cclasses/create', params: {member_cclass: valid_params}
      end

      it 'Should return http status created' do
        expect(response).to have_http_status(:created)
      end

      it 'should exists only one member_cclass' do
        expect(MemberCclass.all.length).to eq(1)
      end
    end

    context 'When using invalid_params' do
      before do
        MemberCclass.destroy_all
        post '/member_cclasses/create', params: {member_cclass: invalid_params}
      end

      it 'Should return http status bad_request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'should not exists member_cclass' do
        expect(MemberCclass.all.length).to eq(0)
      end
    end
  end

  describe "GET /index" do
    before do
      create(:member_cclass)
      create(:member_cclass)
    end

    it "Should returns http status ok" do
      get "/member_cclasses/index"
      expect(response).to have_http_status(:ok)
    end

    it "Should returns 2 objects" do
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe "DELETE /destroy" do
    
    let (:member_cclass) {create(:member_cclass)}

    context "When member_cclass exists" do
      before do
        delete "/member_cclasses/#{member_cclass.id}"
      end

      it 'should return http ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'should have deleted the user' do
        expect(MemberCclass.where(id: member_cclass.id)).to eq([])
      end
    end

    context "When member_cclass does not exists" do
      before do
        member_cclass.destroy!
        delete "/member_cclasses/#{member_cclass.id}"
      end

      it 'should return http status bad request' do
        expect(response).to have_http_status(:bad_request)
      end
    end

  end
end
