# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TurmasController, type: :controller do
  let(:admin_user) { create(:user, :admin) }
  let(:professor_user) { create(:user, :professor) }
  let(:aluno_user) { create(:user, :aluno) }
  let(:curso) { create(:curso) }
  let(:disciplina) { create(:disciplina, curso: curso) }
  let(:turma) { create(:turma, disciplina: disciplina, professor: professor_user) }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(admin_user)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      allow(Turma).to receive(:all).and_return([turma])
      get :index
      expect(response).to be_successful
      expect(assigns(:turmas)).to eq([turma])
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: turma.id }
      expect(response).to be_successful
      expect(assigns(:turma)).to eq(turma)
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
      expect(assigns(:turma)).to be_a_new(Turma)
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, params: { id: turma.id }
      expect(response).to be_successful
      expect(assigns(:turma)).to eq(turma)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_attributes) do
        {
          disciplina_id: disciplina.id,
          professor_id: professor_user.id,
          semestre: '2024.1'
        }
      end

      it 'creates a new Turma' do
        expect {
          post :create, params: { turma: valid_attributes }
        }.to change(Turma, :count).by(1)
      end

      it 'redirects to the created turma' do
        post :create, params: { turma: valid_attributes }
        expect(response).to redirect_to(Turma.last)
        expect(flash[:notice]).to eq('Turma was successfully created.')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          disciplina_id: nil,
          professor_id: nil,
          semestre: ''
        }
      end

      it 'does not create a new Turma' do
        expect {
          post :create, params: { turma: invalid_attributes }
        }.to change(Turma, :count).by(0)
      end

      it 'renders the new template with unprocessable_entity status' do
        post :create, params: { turma: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end

    context 'JSON format' do
      let(:valid_attributes) do
        {
          disciplina_id: disciplina.id,
          professor_id: professor_user.id,
          semestre: '2024.1'
        }
      end

      it 'creates turma and returns JSON' do
        expect {
          post :create, params: { turma: valid_attributes }, format: :json
        }.to change(Turma, :count).by(1)
        
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
      end

      it 'returns errors for invalid data' do
        invalid_attributes = { disciplina_id: nil, professor_id: nil }
        post :create, params: { turma: invalid_attributes }, format: :json
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          semestre: '2024.2'
        }
      end

      it 'updates the requested turma' do
        patch :update, params: { id: turma.id, turma: new_attributes }
        turma.reload
        expect(turma.semestre).to eq('2024.2')
      end

      it 'redirects to the turma' do
        patch :update, params: { id: turma.id, turma: new_attributes }
        expect(response).to redirect_to(turma)
        expect(flash[:notice]).to eq('Turma was successfully updated.')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          disciplina_id: nil,
          professor_id: nil
        }
      end

      it 'renders the edit template with unprocessable_entity status' do
        patch :update, params: { id: turma.id, turma: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end
    end

    context 'JSON format' do
      let(:new_attributes) do
        {
          semestre: '2024.2'
        }
      end

      it 'updates turma and returns JSON' do
        patch :update, params: { id: turma.id, turma: new_attributes }, format: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
      end

      it 'returns errors for invalid data' do
        invalid_attributes = { semestre: '' } # Use only invalid but non-null constraint attributes
        patch :update, params: { id: turma.id, turma: invalid_attributes }, format: :json
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested turma' do
      turma_to_delete = create(:turma, disciplina: disciplina, professor: professor_user)
      expect {
        delete :destroy, params: { id: turma_to_delete.id }
      }.to change(Turma, :count).by(-1)
    end

    it 'redirects to the turmas list' do
      delete :destroy, params: { id: turma.id }
      expect(response).to redirect_to(turmas_url)
      expect(flash[:notice]).to eq('Turma was successfully destroyed.')
    end

    context 'JSON format' do
      it 'returns no content status' do
        delete :destroy, params: { id: turma.id }, format: :json
        expect(response).to have_http_status(:no_content)
      end
    end
  end

  describe 'private methods' do
    describe '#set_turma' do
      it 'sets the turma instance variable' do
        get :show, params: { id: turma.id }
        expect(assigns(:turma)).to eq(turma)
      end
    end

    describe '#turma_params' do
      it 'permits only allowed parameters' do
        controller.params = ActionController::Parameters.new(
          turma: {
            disciplina_id: disciplina.id,
            professor_id: professor_user.id,
            semestre: '2024.1',
            forbidden_param: 'value'
          }
        )
        
        permitted_params = controller.send(:turma_params)
        expect(permitted_params.keys).to contain_exactly('disciplina_id', 'professor_id', 'semestre')
      end
    end
  end

  describe 'error handling' do
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
        patch :update, params: { id: 999999, turma: { semestre: '2024.1' } }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'handles record not found for destroy' do
      expect {
        delete :destroy, params: { id: 999999 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'response formats' do
    it 'handles HTML format for index' do
      get :index
      expect(response.content_type).to include('text/html')
    end

    it 'handles JSON format for index' do
      get :index, format: :json
      expect(response.content_type).to include('application/json')
    end

    it 'handles HTML format for show' do
      get :show, params: { id: turma.id }
      expect(response.content_type).to include('text/html')
    end

    it 'handles JSON format for show' do
      get :show, params: { id: turma.id }, format: :json
      expect(response.content_type).to include('application/json')
    end
  end

  describe 'authorization' do
    context 'when user is admin' do
      it 'allows access to all actions' do
        get :index
        expect(response).to be_successful
      end
    end

    context 'when user is professor' do
      before do
        allow(controller).to receive(:current_user).and_return(professor_user)
      end

      it 'allows access to index' do
        get :index
        expect(response).to be_successful
      end
    end

    context 'when user is aluno' do
      before do
        allow(controller).to receive(:current_user).and_return(aluno_user)
      end

      it 'allows access to index' do
        get :index
        expect(response).to be_successful
      end
    end
  end
end
