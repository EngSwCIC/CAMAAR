require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe MembersController, type: :controller do
  describe 'GET #redefine_password' do
    context 'when the redefinition_link is valid' do
      let(:members_class) { class_double(Member).as_stubbed_const }

      before do
        @good_member = create(:member)

        get :redefine_password, params: { redefinition_link: 'link_correto_de_redefinicao_de_senha' }
      end

      it 'responds with a JSON object indicating success' do
        allow(members_class).to receive(:where).with(redefinition_link: 'link_correto_de_redefinicao_de_senha').and_return(@good_member)
        expect(response).to have_http_status(:ok)
      end

      it 'responds the right member fields' do
        allow(members_class).to receive(:where)
          .with(redefinition_link: 'link_correto_de_redefinicao_de_senha')
          .and_return(@good_member)
        expect_body = JSON.parse(response.body)
        expect(expect_body).to eq(
          JSON.parse(@good_member.to_json)
        )
      end
    end

    context 'when the redefinition_link is not valid' do
      let(:members_class) { class_double(Member).as_stubbed_const }

      before do
        get :redefine_password, params: { redefinition_link: 'link_errado_de_redefinicao_de_senha' }
      end

      it 'responds with a JSON object indicating success' do
        allow(members_class).to receive(:where)
          .with(redefinition_link: 'link_errado_de_redefinicao_de_senha')
          .and_return([])
        expect(response).to have_http_status(:ok)
      end

      it 'responds with nil body' do
        allow(members_class).to receive(:where)
          .with(redefinition_link: 'link_errado_de_redefinicao_de_senha')
          .and_return([])
        expect_body = JSON.parse(response.body)
        expect(expect_body).to eq(nil)
      end
    end

    context 'With no redefinition link parameter' do
      it 'Expects 404' do
        expect(get: '/members/redefine_password/').to route_to(
          controller: 'members',
          action: 'show',
          id: 'redefine_password'
        )
      end
    end
  end
  describe 'GET #index' do
    context 'When I am not sign in' do
      it 'returns unauthorized' do
        get :index, params: {}
        expect(response).to have_http_status(:unauthorized)
      end
    end
    context 'When I am sign in' do
      login_user
      before do
        get :index, params: {}
      end
      it 'returns status code ok' do
        expect(response).to have_http_status(:ok)
      end
    end
  end
  describe 'GET #show' do
    context 'When I am not sign in' do
      it 'returns unauthorized' do
        get :show, params: { id: 1 }
        expect(response).to have_http_status(:unauthorized)
      end
    end
    context 'When I am sign in' do
      login_user
      before do
        get :show, params: { id: 69 }
      end
      it 'returns status code ok' do
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
