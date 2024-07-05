# spec/controllers/respostas_controller_spec.rb
require 'rails_helper'

RSpec.describe RespostasController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns @respostas' do
      resposta = Resposta.create!({ resposta: 'answer', numero: 1 })
      get :index
      expect(assigns(:respostas)).to eq([resposta])
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      resposta = Resposta.create!({ resposta: 'answer', numero: 1 })
      get :show, params: { id: resposta.to_param }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end

    it 'assigns a new resposta as @resposta' do
      get :new
      expect(assigns(:resposta)).to be_a_new(Resposta)
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      resposta = Resposta.create!({ resposta: 'answer', numero: 1 })
      get :edit, params: { id: resposta.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Resposta' do
        expect {
          post :create, params: { resposta: { resposta: 'answer', numero: 1 } }
        }.to change(Resposta, :count).by(1)
      end

      it 'redirects to the created resposta' do
        post :create, params: { resposta: { resposta: 'answer', numero: 1 } }
        expect(response).to redirect_to(resposta_url(Resposta.last))
      end
    end

    context 'with invalid params' do
      it 'returns a success response (i.e., to display the "new" template)' do
        post :create, params: { resposta: { usuario: nil, resposta: nil, numero: nil } }
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      let(:new_attributes) { { resposta: 'new answer' } }

      it 'updates the requested resposta' do
        resposta = Resposta.create!({ resposta: 'answer', numero: 1 })
        patch :update, params: { id: resposta.to_param, resposta: new_attributes }
        resposta.reload
        expect(resposta.resposta).to eq('new answer')
      end

      it 'redirects to the resposta' do
        resposta = Resposta.create!({ resposta: 'answer', numero: 1 })
        patch :update, params: { id: resposta.to_param, resposta: new_attributes }
        expect(response).to redirect_to(resposta_url(resposta))
      end
    end

    context 'with invalid params' do
      it 'returns a success response (i.e., to display the "edit" template)' do
        resposta = Resposta.create!({ resposta: 'answer', numero: 1 })
        patch :update, params: { id: resposta.to_param, resposta: { id_questao: nil } }
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested resposta' do
      resposta = Resposta.create!({ resposta: 'answer', numero: 1 })
      expect {
        delete :destroy, params: { id: resposta.to_param }
      }.to change(Resposta, :count).by(-1)
    end

    it 'redirects to the respostas list' do
      resposta = Resposta.create!({ resposta: 'answer', numero: 1 })
      delete :destroy, params: { id: resposta.to_param }
      expect(response).to redirect_to(respostas_url)
    end
  end
end
