require 'rails_helper'

RSpec.describe RespostaController, type: :controller do
  let(:admin_user) { create(:user, role: :admin) }
  let(:aluno_user) { create(:user, role: :aluno) }
  let(:template) { create(:template, criado_por: admin_user) }
  let(:formulario) { create(:formulario, template: template, coordenador: admin_user) }
  let(:pergunta) { create(:perguntum, template: template) }
  let(:respostum) { create(:respostum, pergunta: pergunta, formulario: formulario) }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'when user is admin' do
    before do
      allow(controller).to receive(:current_user).and_return(admin_user)
    end

    describe 'GET #index' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end

      it 'assigns all resposta' do
        respostum
        get :index
        expect(assigns(:resposta)).to include(respostum)
      end
    end

    describe 'GET #show' do
      it 'returns a success response' do
        get :show, params: { id: respostum.to_param }
        expect(response).to be_successful
      end

      it 'assigns the requested respostum' do
        get :show, params: { id: respostum.to_param }
        expect(assigns(:respostum)).to eq(respostum)
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new
        expect(response).to be_successful
      end

      it 'assigns a new respostum' do
        get :new
        expect(assigns(:respostum)).to be_a_new(Respostum)
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        get :edit, params: { id: respostum.to_param }
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      let(:valid_attributes) do
        {
          resposta_texto: 'Resposta teste',
          pergunta_id: pergunta.id,
          formulario_id: formulario.id,
          uuid_anonimo: SecureRandom.uuid
        }
      end

      context 'with valid parameters' do
        it 'creates a new Respostum' do
          expect {
            post :create, params: { respostum: valid_attributes }
          }.to change(Respostum, :count).by(1)
        end

        it 'redirects to the created respostum' do
          post :create, params: { respostum: valid_attributes }
          expect(response).to redirect_to(Respostum.last)
        end
      end

      context 'with invalid parameters' do
        let(:invalid_attributes) { { resposta_texto: '' } }

        it 'does not create a new Respostum' do
          expect {
            post :create, params: { respostum: invalid_attributes }
          }.to change(Respostum, :count).by(0)
        end

        it 'renders the new template' do
          post :create, params: { respostum: invalid_attributes }
          expect(response).to render_template('new')
        end
      end

      context 'JSON format' do
        it 'creates resposta and returns JSON' do
          expect {
            post :create, params: { respostum: valid_attributes }, format: :json
          }.to change(Respostum, :count).by(1)
          
          expect(response).to have_http_status(:created)
          expect(response.content_type).to include('application/json')
        end

        it 'returns errors for invalid data' do
          invalid_attributes = { resposta_texto: '' }
          post :create, params: { respostum: invalid_attributes }, format: :json
          
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to include('application/json')
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid parameters' do
        let(:new_attributes) { { resposta_texto: 'Resposta atualizada' } }

        it 'updates the requested respostum' do
          put :update, params: { id: respostum.to_param, respostum: new_attributes }
          respostum.reload
          expect(respostum.resposta_texto).to eq('Resposta atualizada')
        end

        it 'redirects to the respostum' do
          put :update, params: { id: respostum.to_param, respostum: new_attributes }
          expect(response).to redirect_to(respostum)
        end
      end

      context 'with invalid parameters' do
        it 'renders the edit template' do
          put :update, params: { id: respostum.to_param, respostum: { resposta_texto: '' } }
          expect(response).to render_template('edit')
        end
      end

      context 'JSON format' do
        let(:new_attributes) { { resposta_texto: 'Resposta JSON atualizada' } }

        it 'updates resposta and returns JSON' do
          put :update, params: { id: respostum.to_param, respostum: new_attributes }, format: :json
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to include('application/json')
        end

        it 'returns errors for invalid data' do
          invalid_attributes = { resposta_texto: '' }
          put :update, params: { id: respostum.to_param, respostum: invalid_attributes }, format: :json
          
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to include('application/json')
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested respostum' do
        respostum
        expect {
          delete :destroy, params: { id: respostum.to_param }
        }.to change(Respostum, :count).by(-1)
      end

      it 'redirects to the resposta list' do
        delete :destroy, params: { id: respostum.to_param }
        expect(response).to redirect_to(resposta_url)
      end

      context 'JSON format' do
        it 'returns no content status' do
          delete :destroy, params: { id: respostum.to_param }, format: :json
          expect(response).to have_http_status(:no_content)
        end
      end
    end
  end

  describe 'when user is aluno' do
    before do
      allow(controller).to receive(:current_user).and_return(aluno_user)
    end

    describe 'GET #index' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end

      it 'handles JSON format' do
        get :index, format: :json
        expect(response.content_type).to include('application/json')
      end
    end

    describe 'GET #show' do
      it 'returns a success response' do
        get :show, params: { id: respostum.to_param }
        expect(response).to be_successful
      end

      it 'handles JSON format' do
        get :show, params: { id: respostum.to_param }, format: :json
        expect(response.content_type).to include('application/json')
      end
    end

    describe 'POST #create as aluno' do
      let(:valid_attributes) do
        {
          resposta_texto: 'Resposta de aluno',
          pergunta_id: pergunta.id,
          formulario_id: formulario.id,
          uuid_anonimo: SecureRandom.uuid
        }
      end

      it 'can create respostas' do
        expect {
          post :create, params: { respostum: valid_attributes }
        }.to change(Respostum, :count).by(1)
      end
    end
  end

  describe 'error handling and edge cases' do
    before do
      allow(controller).to receive(:current_user).and_return(admin_user)
    end

    it 'handles record not found for show' do
      expect {
        get :show, params: { id: 999999 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'handles record not found for edit' do
      expect {
        get :edit, params: { id: 999999 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'handles record not found for update' do
      expect {
        put :update, params: { id: 999999, respostum: { resposta_texto: 'Test' } }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'handles record not found for destroy' do
      expect {
        delete :destroy, params: { id: 999999 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'parameter handling' do
    before do
      allow(controller).to receive(:current_user).and_return(admin_user)
    end

    it 'permits only allowed parameters' do
      controller.params = ActionController::Parameters.new(
        respostum: {
          pergunta_id: pergunta.id,
          formulario_id: formulario.id,
          resposta_texto: 'Teste',
          uuid_anonimo: 'uuid-test',
          opcao_id: 1,
          forbidden_param: 'value'
        }
      )
      
      permitted_params = controller.send(:respostum_params)
      expected_keys = ['pergunta_id', 'formulario_id', 'resposta_texto', 'uuid_anonimo', 'opcao_id']
      expect(permitted_params.keys.sort).to eq(expected_keys.sort)
    end
  end
end
