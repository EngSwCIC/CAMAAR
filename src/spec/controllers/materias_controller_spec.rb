# spec/controllers/materias_controller_spec.rb
require 'rails_helper'

RSpec.describe MateriasController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns @materias' do
      materia = Materia.create!({ code: 'MATH101', nome: 'Mathematics' })
      get :index
      expect(assigns(:materias)).to eq([materia])
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      materia = Materia.create!({ code: 'MATH101', nome: 'Mathematics' })
      get :show, params: { id: materia.to_param }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end

    it 'assigns a new materia as @materia' do
      get :new
      expect(assigns(:materia)).to be_a_new(Materia)
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      materia = Materia.create!({ code: 'MATH101', nome: 'Mathematics' })
      get :edit, params: { id: materia.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
  context 'with invalid params' do
    it 'does not create a new Materia' do
      expect {
        post :create, params: { materia: { code: 'MATH101', nome: nil } }
      }.to_not change(Materia, :count)
    end

    it 'renders the new template with unprocessable_entity status' do
      post :create, params: { materia: { code: 'MATH101', nome: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:new)
    end

    it 'assigns a new unsaved materia as @materia' do
      post :create, params: { materia: { code: 'MATH101', nome: nil } }
      expect(assigns(:materia)).to be_a_new(Materia)
      expect(assigns(:materia)).not_to be_persisted
    end

    it 'returns error details in JSON format' do
      post :create, params: { materia: { code: 'MATH101', nome: nil } }, format: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to include("nome" => ["can't be blank"])
    end
  end
end

describe 'PATCH #update' do
let(:materia) { Materia.create!({ code: 'MATH101', nome: 'Mathematics' }) }

context 'with invalid params' do
  it 'does not update the requested materia' do
    patch :update, params: { id: materia.to_param, materia: { nome: nil } }
    materia.reload
    expect(materia.nome).to eq('Mathematics')
  end

  it 'renders the edit template with unprocessable_entity status' do
    patch :update, params: { id: materia.to_param, materia: { nome: nil } }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response).to render_template(:edit)
  end

  it 'returns error details in JSON format' do
    patch :update, params: { id: materia.to_param, materia: { nome: nil } }, format: :json
    expect(response).to have_http_status(:unprocessable_entity)
    expect(JSON.parse(response.body)).to include("nome" => ["can't be blank"])
  end
end
end

  describe 'DELETE #destroy' do
    let!(:materia) { Materia.create!({ code: 'MATH101', nome: 'Mathematics' }) }

    it 'destroys the requested materia' do
      expect {
        delete :destroy, params: { id: materia.to_param }
      }.to change(Materia, :count).by(-1)
    end

    it 'redirects to the materias list' do
      delete :destroy, params: { id: materia.to_param }
      expect(response).to redirect_to(materias_url)
    end
  end
end
