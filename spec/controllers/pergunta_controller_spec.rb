require 'rails_helper'

RSpec.describe PerguntaController, type: :controller do
  let(:admin_user) { create(:user, :admin) }
  let(:professor_user) { create(:user, :professor) }
  let(:aluno_user) { create(:user, :aluno) }
  let(:template) { create(:template, criado_por: admin_user) }
  let(:pergunta) { create(:perguntum, template: template) }

  describe 'when signed in as admin' do
    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:current_user).and_return(admin_user)
    end

    describe 'GET #index' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end

      it 'assigns all perguntas' do
        pergunta
        get :index
        expect(assigns(:pergunta)).to include(pergunta)
      end

      it 'handles JSON format' do
        get :index, format: :json
        expect(response.content_type).to include('application/json')
      end
    end

    describe 'GET #show' do
      it 'returns a success response' do
        get :show, params: { id: pergunta.id }
        expect(response).to be_successful
      end

      it 'assigns the requested pergunta' do
        get :show, params: { id: pergunta.id }
        expect(assigns(:perguntum)).to eq(pergunta)
      end

      it 'handles JSON format' do
        get :show, params: { id: pergunta.id }, format: :json
        expect(response.content_type).to include('application/json')
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new
        expect(response).to be_successful
      end

      it 'assigns a new pergunta' do
        get :new
        expect(assigns(:perguntum)).to be_a_new(Perguntum)
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        get :edit, params: { id: pergunta.id }
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      context 'with valid parameters' do
        let(:valid_attributes) do
          {
            texto: 'Nova pergunta?',
            tipo: 'subjetiva',
            template_id: template.id,
            obrigatoria: true
          }
        end

        it 'creates a new Pergunta' do
          expect {
            post :create, params: { perguntum: valid_attributes }
          }.to change(Perguntum, :count).by(1)
        end

        it 'redirects to the created pergunta' do
          post :create, params: { perguntum: valid_attributes }
          expect(response).to redirect_to(Perguntum.last)
        end
      end

      context 'with invalid parameters' do
        let(:invalid_attributes) { { texto: '', template_id: nil } }

        it 'does not create a new Pergunta' do
          expect {
            post :create, params: { perguntum: invalid_attributes }
          }.to change(Perguntum, :count).by(0)
        end

        it 'renders the new template' do
          post :create, params: { perguntum: invalid_attributes }
          expect(response).to render_template('new')
        end
      end

      context 'JSON format' do
        let(:valid_attributes) do
          {
            texto: 'Pergunta JSON?',
            tipo: 'subjetiva',
            template_id: template.id,
            obrigatoria: true
          }
        end

        it 'creates pergunta and returns JSON' do
          expect {
            post :create, params: { perguntum: valid_attributes }, format: :json
          }.to change(Perguntum, :count).by(1)
          
          expect(response).to have_http_status(:created)
          expect(response.content_type).to include('application/json')
        end

        it 'returns errors for invalid data' do
          invalid_attributes = { texto: '', template_id: nil }
          post :create, params: { perguntum: invalid_attributes }, format: :json
          
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to include('application/json')
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid parameters' do
        let(:new_attributes) { { texto: 'Pergunta atualizada?' } }

        it 'updates the requested pergunta' do
          put :update, params: { id: pergunta.id, perguntum: new_attributes }
          pergunta.reload
          expect(pergunta.texto).to eq('Pergunta atualizada?')
        end

        it 'redirects to the pergunta' do
          put :update, params: { id: pergunta.id, perguntum: new_attributes }
          expect(response).to redirect_to(pergunta)
        end
      end

      context 'with invalid parameters' do
        let(:invalid_attributes) { { texto: '', template_id: nil } }

        it 'renders the edit template' do
          put :update, params: { id: pergunta.id, perguntum: invalid_attributes }
          expect(response).to render_template('edit')
        end
      end

      context 'JSON format' do
        let(:new_attributes) { { texto: 'Pergunta JSON atualizada?' } }

        it 'updates pergunta and returns JSON' do
          put :update, params: { id: pergunta.id, perguntum: new_attributes }, format: :json
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to include('application/json')
        end

        it 'returns errors for invalid data' do
          invalid_attributes = { texto: '', template_id: nil }
          put :update, params: { id: pergunta.id, perguntum: invalid_attributes }, format: :json
          
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to include('application/json')
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested pergunta' do
        pergunta
        expect {
          delete :destroy, params: { id: pergunta.id }
        }.to change(Perguntum, :count).by(-1)
      end

      it 'redirects to the pergunta list' do
        delete :destroy, params: { id: pergunta.id }
        expect(response).to redirect_to(pergunta_path)
      end

      context 'JSON format' do
        it 'returns no content status' do
          delete :destroy, params: { id: pergunta.id }, format: :json
          expect(response).to have_http_status(:no_content)
        end
      end
    end
  end

  describe 'when signed in as professor' do
    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:current_user).and_return(professor_user)
    end

    describe 'GET #index' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new
        expect(response).to be_successful
      end
    end
  end

  describe 'when signed in as aluno' do
    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:current_user).and_return(aluno_user)
    end

    describe 'GET #index' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      let(:valid_attributes) do
        {
          texto: 'Nova pergunta aluno?',
          tipo: 'subjetiva',
          template_id: template.id,
          obrigatoria: true
        }
      end

      it 'allows creating pergunta' do
        expect {
          post :create, params: { perguntum: valid_attributes }
        }.to change(Perguntum, :count).by(1)
      end
    end
  end

  describe 'private methods' do
    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:current_user).and_return(admin_user)
    end

    describe '#set_perguntum' do
      it 'sets the pergunta from params' do
        get :edit, params: { id: pergunta.id }
        expect(assigns(:perguntum)).to eq(pergunta)
      end
    end

    describe '#perguntum_params' do
      it 'permits only allowed parameters' do
        controller.params = ActionController::Parameters.new(
          perguntum: {
            template_id: template.id,
            texto: 'Pergunta teste',
            tipo: 'subjetiva',
            obrigatoria: true,
            titulo: 'Título',
            ordem: 1,
            forbidden_param: 'value'
          }
        )
        
        permitted_params = controller.send(:perguntum_params)
        expected_keys = ['template_id', 'texto', 'tipo', 'obrigatoria', 'titulo', 'ordem']
        expect(permitted_params.keys.sort).to eq(expected_keys.sort)
      end
    end
  end

  describe 'error handling' do
    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
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
        put :update, params: { id: 999999, perguntum: { texto: 'Test' } }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'handles record not found for destroy' do
      expect {
        delete :destroy, params: { id: 999999 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
