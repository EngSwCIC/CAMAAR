require 'rails_helper'

RSpec.describe FormularioTemplatesController, type: :controller do
  describe 'GET #index' do
    it 'retorna a lista de formulario_templates' do
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:formulario_templates)).not_to be_nil
    end
  end

  describe 'GET #show' do
    it 'retorna o template de formulário específico' do
      formulario_template = FactoryBot.create(:formulario_template)
      get :show, params: { id: formulario_template.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:formulario_template)).to eq(formulario_template)
    end
  end

  describe 'GET #new' do
    it 'renderiza o formulário para criar um novo template de formulário' do
      get :new
      expect(response).to have_http_status(:success)
      expect(assigns(:formulario_template)).to be_a_new(FormularioTemplate)
    end
  end
end