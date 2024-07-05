require 'rails_helper'

RSpec.describe QuestoesController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    let(:questao) { create(:questao) }

    it 'returns a success response' do
      get :show, params: { id: questao.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    let(:questao) { create(:questao) }

    it 'returns a success response' do
      get :edit, params: { id: questao.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Questao' do
        expect {
          post :create, params: { questao: attributes_for(:questao) }
        }.to change(Questao, :count).by(1)
      end

      it 'redirects to the created questao' do
        post :create, params: { questao: attributes_for(:questao) }
        expect(response).to redirect_to(questao_url(Questao.last))
      end
    end

  end

  describe 'PATCH #update' do
    let(:questao) { create(:questao) }

    context 'with valid params' do
      it 'updates the requested questao' do
        patch :update, params: { id: questao.id, questao: { tipo: 'updated_type' } }
        questao.reload
        expect(questao.tipo).to eq('updated_type')
      end

      it 'redirects to the questao' do
        patch :update, params: { id: questao.id, questao: attributes_for(:questao) }
        expect(response).to redirect_to(questao_url(questao))
      end
    end

  end

  describe 'DELETE #destroy' do
    let!(:questao) { create(:questao) }

    it 'destroys the requested questao' do
      expect {
        delete :destroy, params: { id: questao.id }
      }.to change(Questao, :count).by(-1)
    end

    it 'redirects to the questoes list' do
      delete :destroy, params: { id: questao.id }
      expect(response).to redirect_to(questoes_url)
    end
  end
end
